class PreferencesController < ApplicationController
  # GET /preferences
  # GET /preferences.xml
  def index
	@staff = Staff.find(params[:staff_id])
    @preferences = Preference.where(:staff_id => @staff.id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @preferences }
    end
  end

  # GET /preferences/1
  # GET /preferences/1.xml
  def show
    @preference = Preference.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @preference }
    end
  end

  # GET /preferences/new
  # GET /preferences/new.xml
  def new
	@staff = Staff.find(params[:staff_id])
    @preference = Preference.new(:staff_id=>@staff.id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @preference }
    end
  end

  # GET /preferences/1/edit
  def edit
    @staff = Staff.find(params[:staff_id])
    @preference = Preference.find(params[:id])
  end

  # POST /preferences
  # POST /preferences.xml
  def create
    @staff = Staff.find(params[:staff_id])
	# Do not create another value under same name
	rt = params[:preference][:name]
    @preference = Preference.find_by_staff_id_and_name(@staff.id, params[:preference][:name]) || Preference.new(params[:preference])
	@preference.value = params[:preference][:value] 

    respond_to do |format|
      if @preference.save
        format.html { redirect_to(edit_staff_path(@staff), :notice => 'Preference was successfully created.') }
        format.xml  { render :xml => edit_staff_path(@staff), :status => :created, :location => @preference }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @preference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /preferences/1
  # PUT /preferences/1.xml
  def update
    @preference = Preference.find(params[:id])

    respond_to do |format|
      if @preference.update_attributes(params[:preference])
        format.html { redirect_to(staff_preferences_path(@staff), :notice => 'Preference was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @preference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /preferences/1
  # DELETE /preferences/1.xml
  def destroy
    @staff = Staff.find(params[:staff_id])
    @preference = Preference.find(params[:id])
    @preference.destroy

    respond_to do |format|
      format.html { redirect_to(staff_preferences_url) }
      format.xml  { head :ok }
    end
  end
end
