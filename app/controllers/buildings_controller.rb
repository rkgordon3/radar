class BuildingsController < ApplicationController
  # GET /buildings
  # GET /buildings.xml  before_filter :super_admin_authorize_view_access, :except => [:show, :index]
  before_filter :authenticate_staff!
  load_and_authorize_resource

  def index
    @numRows = 0

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @buildings }
    end
  end

  # GET /buildings/1
  # GET /buildings/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @building }
    end
  end
  
  def select
  	  @buildings = Building.all
  end

  # GET /buildings/new
  # GET /buildings/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @building }
    end
  end

  # GET /buildings/1/edit
  def edit
    # @building automatically loaded by CanCan
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
        format.html { redirect_to(@building, :notice => 'Building was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @building.errors, :status => :unprocessable_entity }
      end
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
