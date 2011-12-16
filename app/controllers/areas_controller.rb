class AreasController < ApplicationController
  # GET /areas
  # GET /areas.xml
  before_filter :authenticate_staff!
  load_and_authorize_resource

  def index
    sort = params[:sort]
    @areas = @areas.where("id <> ?", Area.unspecified_id)
    #@areas = Area.sort(sort)
    msg = "Buildings are now sorted by #{sort}."
    unassigned_buildings = Building.where( :area_id => Area.unspecified_id )

    respond_to do |format|
      format.html { render :locals => { :unassigned_buildings => unassigned_buildings } }
      format.js { render :locals => { :unassigned_buildings => unassigned_buildings, :flash_notice => msg }}
    end
  end

  # POST /buildings
  # POST /buildings.xml
  def create
    @area.buildings = Building.find(params[:buildings])
    authorize! :create, @area
    @areas = Area.accessible_by(current_ability)
    @areas = @areas.where("id <> ?", Area.unspecified_id)

    respond_to do |format|
      if @area.save
        msg = "#{@area.name} has been successfully created."
      else
        msg = "Error: Area NOT created!"
      end
      unassigned_buildings = Building.where( :area_id => Area.unspecified_id )
      format.js { render "areas/index", :locals => { :unassigned_buildings => unassigned_buildings, :flash_notice => msg } }
    end
  end

  # PUT /buildings/1
  # PUT /buildings/1.xml
  def update
    buildings_to_be_assigned = Building.find(params[:buildings])
    @area.buildings =  buildings_to_be_assigned
    authorize! :update, @area
    @areas = Area.accessible_by(current_ability)
    @areas = @areas.where("id <> ?", Area.unspecified_id)
    respond_to do |format|
      if @area.update_attributes(params[:area])
        msg = "#{@area.name} has been successfully updated."
      else
        msg = "Error: Area NOT updated!"
      end
      unassigned_buildings = Building.where( :area_id => Area.unspecified_id )
      format.js { render "areas/index", :locals => { :unassigned_buildings => unassigned_buildings, :flash_notice => msg } }
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.xml
  def destroy
    msg = "#{@area.name} has been successfully destroyed."
    id = @area.id
    @area.destroy
    unassigned_buildings = Building.where( :area_id => Area.unspecified_id )
    @areas = Area.accessible_by(current_ability)
    @areas = @areas.where("id <> ?", Area.unspecified_id)
    respond_to do |format|
      format.js { render "areas/index", :locals => { :unassigned_buildings => unassigned_buildings, :flash_notice => msg } }
    end
  end
end
