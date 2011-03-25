class ReportParticipantRelationshipsController < ApplicationController
  # GET /reported_infractions
  # GET /reported_infractions.xml
  before_filter :admin_authorize
  def index
    
    @report_participant_relationships = ReportParticipantRelationship.all
    @numRows = 0

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @report_participant_relationships }
    end
  end

  # GET /reported_infractions/1
  # GET /reported_infractions/1.xml
  def show
    @report_participant_relationship = ReportParticipantRelationship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report_participant_relationship }
    end
  end

  # GET /reported_infractions/new
  # GET /reported_infractions/new.xml
  def new
    @report_participant_relationship = ReportParticipantRelationship.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report_participant_relationship }
    end
  end

  # GET /reported_infractions/1/edit
  def edit
    @report_participant_relationship = ReportParticipantRelationship.find(params[:id])
  end

  # POST /reported_infractions
  # POST /reported_infractions.xml
  def create
    @report_participant_relationship = ReportParticipantRelationship.new(params[:report_participant_relationship])

    respond_to do |format|
      if @report_participant_relationship.save
        format.html { redirect_to(@report_participant_relationship, :notice => 'Reported infraction was successfully created.') }
        format.xml  { render :xml => @report_participant_relationship, :status => :created, :location => @report_participant_relationship }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report_participant_relationship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reported_infractions/1
  # PUT /reported_infractions/1.xml
  def update
    @report_participant_relationship = ReportParticipantRelationship.find(params[:id])

    respond_to do |format|
      if @report_participant_relationship.update_attributes(params[:report_participant_relationship])
        format.html { redirect_to(@report_participant_relationship, :notice => 'Report-participant relationship was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_participant_relationship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reported_infractions/1
  # DELETE /reported_infractions/1.xml
  def destroy
    @report_participant_relationship = ReportParticipantRelationship.find(params[:id])
    @report_participant_relationship.destroy

    respond_to do |format|
      format.html { redirect_to(report_participant_relationship_url) }
      format.xml  { head :ok }
    end
  end
end
