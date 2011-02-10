class ReportLocationsController < ApplicationController
  # GET /report_locations
  # GET /report_locations.xml
  def index
    @report_locations = ReportLocation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @report_locations }
    end
  end

  # GET /report_locations/1
  # GET /report_locations/1.xml
  def show
    @report_location = ReportLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report_location }
    end
  end

  # GET /report_locations/new
  # GET /report_locations/new.xml
  def new
    @report_location = ReportLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report_location }
    end
  end

  # GET /report_locations/1/edit
  def edit
    @report_location = ReportLocation.find(params[:id])
  end

  # POST /report_locations
  # POST /report_locations.xml
  def create
    @report_location = ReportLocation.new(params[:report_location])

    respond_to do |format|
      if @report_location.save
        format.html { redirect_to(@report_location, :notice => 'Report location was successfully created.') }
        format.xml  { render :xml => @report_location, :status => :created, :location => @report_location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /report_locations/1
  # PUT /report_locations/1.xml
  def update
    @report_location = ReportLocation.find(params[:id])

    respond_to do |format|
      if @report_location.update_attributes(params[:report_location])
        format.html { redirect_to(@report_location, :notice => 'Report location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /report_locations/1
  # DELETE /report_locations/1.xml
  def destroy
    @report_location = ReportLocation.find(params[:id])
    @report_location.destroy

    respond_to do |format|
      format.html { redirect_to(report_locations_url) }
      format.xml  { head :ok }
    end
  end
end
