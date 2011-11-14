class BuildingsController < ApplicationController
  # GET /buildings
  before_filter :authenticate_staff!
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def select
    @buildings = Building.all
  end

  # POST /buildings
  # POST /buildings.xml
  def create
    is_shaded = params[:is][:shaded]

    logger.debug "***old #{is_shaded}"
    if is_shaded == "1"
      row_style = "class='shaded'"
      is_shaded = 0
    else
      row_style = ""
      is_shaded = 1
    end
    logger.debug "***new #{is_shaded}"
    
    respond_to do |format|
      if @building.save
        msg = "#{@building.name} created successfully."
      else
        msg = "Error: Building NOT created!"
      end
      format.js { render :locals => { :flash_notice => msg, :row_style => row_style, :is_shaded => is_shaded } }
    end
  end

  # PUT /buildings/1
  # PUT /buildings/1.xml
  def update
    respond_to do |format|
      if @building.update_attributes(params[:building])
        msg = "#{@building.name} updated successfully."
      else
        msg = "Error: Building NOT updated!"
      end
      format.js { render :locals => { :flash_notice => msg, :row_style => params[:row][:style]} }
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.xml
  def destroy
    msg = "#{@building.name} destroyed successfully."
    id = @building.id
    @building.destroy

    respond_to do |format|
      format.js { render :locals => { :flash_notice => msg, :id => id } }
    end
  end
end