class AreasController < ApplicationController
  # GET /areas
  # GET /areas.xml
  before_filter :authenticate_staff!
  load_and_authorize_resource

  def index
    sort = params[:sort]
    @areas = Area.sort(sort)
    msg = "Areas are now sorted by #{sort}."
    unassigned_buildings = Building.where( :area_id => Area.unspecified_id ).order("name ASC")

    respond_to do |format|
      format.html { render :locals => { :unassigned_buildings => unassigned_buildings } }
      format.js { render :locals => { :unassigned_buildings => unassigned_buildings, :flash_notice => msg }}
    end
  end

  # POST /buildings
  # POST /buildings.xml
  def create
    is_shaded = params[:is][:shaded]
    if is_shaded == "1"
      row_style = "class='shaded'"
      is_shaded = 0
    else
      row_style = ""
      is_shaded = 1
    end

    if params[:buildings] != nil
      @area.buildings = Building.find(params[:buildings])
      authorize! :create, @area
    end

    respond_to do |format|
      if @area.save
        msg = "#{@area.name} has been successfully created."
      else
        msg = "Error: Area NOT created!"
      end
      unassigned_buildings = Building.where( :area_id => Area.unspecified_id ).order("name ASC")
      format.js { render :locals => { :row_style => row_style, :is_shaded => is_shaded, :unassigned_buildings => unassigned_buildings, :flash_notice => msg } }
    end
  end

  # PUT /buildings/1
  # PUT /buildings/1.xml
  def update
    params[:area][:buildings] = params[:buildings]
    @areas = Area.sort("name")

    respond_to do |format|
      if @area.update_attributes(params[:area])
        msg = "#{@area.name} has been successfully updated."
      else
        msg = "Error: Area NOT updated!"
      end
      unassigned_buildings = Building.where( :area_id => Area.unspecified_id ).order("name ASC")
      format.js { render "areas/index", :locals => { :unassigned_buildings => unassigned_buildings, :flash_notice => msg } }
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.xml
  def destroy
    msg = "#{@area.name} has been successfully destroyed."
    @area.destroy
    unassigned_buildings = Building.where( :area_id => Area.unspecified_id ).order("name ASC")
    @areas = Area.sort("name")
    
    respond_to do |format|
      format.js { render "areas/index", :locals => { :unassigned_buildings => unassigned_buildings, :flash_notice => msg } }
    end
  end
end
