class ReportedInfractionsController < ApplicationController
  # GET /reported_infractions
  # GET /reported_infractions.xml
  def index
    @reported_infractions = ReportedInfraction.all
    @numRows = 0

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reported_infractions }
    end
  end

  # GET /reported_infractions/1
  # GET /reported_infractions/1.xml
  def show
    @reported_infraction = ReportedInfraction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reported_infraction }
    end
  end

  # GET /reported_infractions/new
  # GET /reported_infractions/new.xml
  def new
    @reported_infraction = ReportedInfraction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reported_infraction }
    end
  end

  # GET /reported_infractions/1/edit
  def edit
    @reported_infraction = ReportedInfraction.find(params[:id])
  end

  # POST /reported_infractions
  # POST /reported_infractions.xml
  def create
    @reported_infraction = ReportedInfraction.new(params[:reported_infraction])

    respond_to do |format|
      if @reported_infraction.save
        format.html { redirect_to(@reported_infraction, :notice => 'Reported infraction was successfully created.') }
        format.xml  { render :xml => @reported_infraction, :status => :created, :location => @reported_infraction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reported_infraction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reported_infractions/1
  # PUT /reported_infractions/1.xml
  def update
    @reported_infraction = ReportedInfraction.find(params[:id])

    respond_to do |format|
      if @reported_infraction.update_attributes(params[:reported_infraction])
        format.html { redirect_to(@reported_infraction, :notice => 'Reported infraction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reported_infraction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reported_infractions/1
  # DELETE /reported_infractions/1.xml
  def destroy
    @reported_infraction = ReportedInfraction.find(params[:id])
    @reported_infraction.destroy

    respond_to do |format|
      format.html { redirect_to(reported_infractions_url) }
      format.xml  { head :ok }
    end
  end
end
