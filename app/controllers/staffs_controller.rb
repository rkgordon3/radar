class StaffsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, :only => [ :new_staff, :create_staff ]
  before_filter :authenticate_staff!
  load_and_authorize_resource :except => :destroy
  

  #++++++++++++++++++ Devise Customization ++++++++++++++++++++++++++++++
  # We need to allow 'sign_up' by a third party. In other words, it is
  # a admin type role that regiesters users. Devise's model is that user
  # signs up for himself. This is enforced by requiring current user NOT to
  # be authenticated when signing up, ie exercising new/create methods of
  # registration controller. 
  #
  # We circumvent this constraint by:
  # 1. Creating new and create proxy actions in StaffController, new_staff and create_staff,
  # respectively. And, of course, adding appropriate routes. We create these proxies so
  # step 2 works. If we enter new/create at Devise::RegistrationsController, we can not
  # leverage skip_before_filter.
  # 2. Using skip_before_filter for :require_no_authentication and limit this "skip"
  # to new_staff and create_staff actions.
  # 3. Directing new user request to new_staff and create user request to create_staff. The
  # former occurs on staffs/index view, the latter on new staff form.
  # 4. Over-ride after_sign_up_path to return to staffs/index.
  # 5. Over-ride sign-up to be a no-op so that admin is not logged and newly registered
  # user logged in (default behavior of devise).
  #
  # We also customize build_resource to setup associations.
  #
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #
  #
  # Over-ride Devise build_resource so that we can build associations.
  #
  # Herein we build staff_organization and staff_area associations
  # 
  def build_resource(hash = {}) 
    staff = super
    # delete all existing
    staff.access_levels.delete_all
    staff.staff_areas.build(staff: staff.id, area_id: params[:area_ids].first)
    params[:org].each { |org_id| 
      staff.staff_organizations.build(:staff_id => staff.id, 
                                    :organization_id=>org_id.to_i, 
                                    :access_level_id =>params[:authorization][org_id.to_s].to_i)
    }
  end

  #
  # Return to staffs/index after sign up
  #
  def after_sign_up_path_for(resource)
    staffs_path
  end

  #
  # We make sign_up a no-op. Existing implementation signs out current user 
  # and signs in newly registered user. Not the approach we want to take 
  # given that our registrations are all done by admin
  #
  def sign_up(resource_or_scope, *args)
  end
  #
  # A proxy for new so that we can skip require_no_authentication filter
  #
  def new_staff
    @staff = Staff.new
    respond_to do |format|
      format.html
    end
  end
  # 
  # A proxy for create. Ditto reasons for new_staff above.
  #
  def create_staff
    create
  end

  def edit
    @staff = Staff.find(params[:id])
    super
  end
  # GET /staffs
  # GET /staffs.xml
  def index
    @numRows = 0
	@staffs = @staffs.uniq
	# This will get me staff for orgs in which current_staff is in, but selection is NOT
	# contrained by abilities. What I really want is orgs in which current_staff has ability
	# to list/view/manage(?) staff
	#@staffs = Staff.joins(:organizations).where(:organizations => { :id => current_staff.organization_ids } )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staffs }
    end 
  end

  # GET /staffs/new
  # GET /staffs/new.xml
  def new_old
    @staff = Staff.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @staff }
      format.iphone {render :layout => 'mobile_application'}
    end
  end

  def activate
	  @staff = Staff.find(params[:staff_id])
	  @staff.active = true
	  @staff.save
	  respond_to do |format|
        format.html { redirect_to(staffs_url) }
        format.xml  { head :ok }
	  end	  
  end

  # DELETE /staffs/1
  # DELETE /staffs/1.xml
  def destroy
    @staff = Staff.find(params[:id])
    authorize! :destroy, @staff
	logger.debug("********************* Set active of #{@staff.id} to false  ************")
    @staff.active = false
	@staff.save

    respond_to do |format|
      format.html { redirect_to(staffs_url) }
      format.xml  { head :ok }
    end
  end
  
  def update
    respond_to do |format|
      if @staff.update_attributes(params[:staff])
        @current_ability = nil
        @current_staff = nil
        format.html { redirect_to(@staff, :notice => 'Staff was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @staff.errors, :status => :unprocessable_entity }
      end
    end
  end
  
   # PUT
  def update_preferences
	staff_id = params[:staff_id]
	ReportType.accessible_by(current_ability).each do |r|
		pref = NotificationPreference.find_by_staff_id_and_report_type(staff_id,r.name) || NotificationPreference.new(:staff_id => staff_id, :report_type => r.name)
		pref.update_attributes(params[r.name.to_sym])
		pref.time_offset = Notification.get_time_offset_for_frequency(pref.frequency)
		pref.save
	end

    respond_to do |format|
      if true
        format.html { redirect_to('/home/landingpage/', :notice => 'Your Notification Preferences were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
      end
    end
  end
  
end
