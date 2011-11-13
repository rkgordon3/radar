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
    respond_to do |format|
      if @building.save
        format.html { redirect_to(@building, :notice => 'Building was successfully created.') }
        format.xml  { render :xml => @building, :status => :created, :location => @building }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @building.errors, :status => :unprocessable_entity }
      end
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
      format.js { render :locals => { :flash_notice => msg, :row_style=>params[:row][:style]} }
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.xml
  def destroy
    @building.destroy

    respond_to do |format|
      format.html { redirect_to(buildings_url) }
      format.xml  { head :ok }
    end
  end
end