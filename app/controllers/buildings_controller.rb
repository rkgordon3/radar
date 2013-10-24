class BuildingsController < ApplicationController
  # GET /buildings
  before_filter :authenticate_staff!
  load_and_authorize_resource

  def index
    sort = params[:sort]
    @buildings = Building.sort(sort)
    msg = "Buildings are now sorted by #{sort}."

    respond_to do |format|
      format.html # index.html.erb
      format.js { render :locals => { :flash_notice => msg }}
    end
  end
  
  def select
    @buildings = Building.all
  end

  # POST /buildings
  # POST /buildings.xml
  def create
    insrt_point = nil # represents the building you will be placing the new building before or after - Dylan
    placement = nil # represents whether insertion is before or after -Dylan
    list_counter = 0 # counter for determining list end -Dylan
    row_style = "class='new_building_shade'"
    Building.order("name DESC").all.each do |b|
      list_counter += 1
      if (@building.name <=> b.name) == -1
        if list_counter == Building.all.length
          insrt_point = b
          placement = :before
        end 
      elsif (@building.name <=> b.name) == 1
        insrt_point = b
        placement = :after
        break
      end
    end
    respond_to do |format|
      if @building.save
        msg = "#{@building.name} has been successfully created and is highlighted below."
      else
        msg = "Error: Building NOT created!"
      end
      format.js { render :locals => { :building => insrt_point, :placement => placement, :flash_notice => msg, :row_style => row_style } }
     end
  end

  # PUT /buildings/1
  # PUT /buildings/1.xml
  def update
    respond_to do |format|
      if @building.update_attributes(params[:building])
        msg = "#{@building.name} has been successfully updated."
      else
        msg = "Error: Building NOT updated!"
      end
      format.js { render :locals => { :flash_notice => msg, :building => @building, :row_style => params[:row][:style]} }
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.xml
  def destroy
    msg = "#{@building.name} has been successfully destroyed."
    @building.destroy

    respond_to do |format|
      format.js { render :locals => { :flash_notice => msg, :building => @building } }
    end
  end
end
