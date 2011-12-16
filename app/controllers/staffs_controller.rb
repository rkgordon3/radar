class StaffsController < Devise::RegistrationsController
  before_filter :authenticate_staff!
  load_and_authorize_resource :except => :destroy
  
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


  # DELETE /staffs/1
  # DELETE /staffs/1.xml
  def destroy
    @staff = Staff.find(params[:id])
    authorize! :destroy, @staff
    @staff.destroy

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
  
end
