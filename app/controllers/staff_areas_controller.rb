class StaffAreasController < ApplicationController
  # GET /staff_areas
  # GET /staff_areas.xml
  def index
    @staff_areas = StaffArea.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staff_areas }
    end
  end

  # GET /staff_areas/1
  # GET /staff_areas/1.xml
  def show
    @staff_area = StaffArea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @staff_area }
    end
  end

  # GET /staff_areas/new
  # GET /staff_areas/new.xml
  def new
    @staff_area = StaffArea.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @staff_area }
    end
  end

  # GET /staff_areas/1/edit
  def edit
    @staff_area = StaffArea.find(params[:id])
  end

  # POST /staff_areas
  # POST /staff_areas.xml
  def create
    @staff_area = StaffArea.new(params[:staff_area])

    respond_to do |format|
      if @staff_area.save
        format.html { redirect_to(@staff_area, :notice => 'Staff area was successfully created.') }
        format.xml  { render :xml => @staff_area, :status => :created, :location => @staff_area }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @staff_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /staff_areas/1
  # PUT /staff_areas/1.xml
  def update
    @staff_area = StaffArea.find(params[:id])

    respond_to do |format|
      if @staff_area.update_attributes(params[:staff_area])
        format.html { redirect_to(@staff_area, :notice => 'Staff area was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @staff_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_areas/1
  # DELETE /staff_areas/1.xml
  def destroy
    @staff_area = StaffArea.find(params[:id])
    @staff_area.destroy

    respond_to do |format|
      format.html { redirect_to(staff_areas_url) }
      format.xml  { head :ok }
    end
  end
  
  def update
    @staff_area.update_attributes(params[:staff_area])
    render :partial => "staffs/index_generic"
    
  end
end
