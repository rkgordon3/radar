class IncidentReportsController < ApplicationController
  before_filter :authorize, :except => :index	
  autocomplete :student, :first_name, :display_value => :full_name
 
  # GET /incident_reports
  # GET /incident_reports.xml
  def index
    @incident_reports = IncidentReport.all
    @numRows

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incident_reports }
    end
  end

  # GET /incident_reports/1
  # GET /incident_reports/1.xml
  def show
    @incident_report = IncidentReport.find(params[:id])
    @currentParticipantID = -1
    

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incident_report }
    end
  end

  # GET /incident_reports/new
  # GET /incident_reports/new.xml
  def new
    @incident_report = IncidentReport.new
    @incident_report.approach_time = Time.now
    @incident_report.staff_id = current_staff.id
    @incident_report.building_id = 16
    @annotation = Annotation.new
    
    r_i = ReportedInfraction.new
    r_i.participant_id = 3
    r_i.infraction_id = 22
    
    @incident_report.reported_infractions << r_i


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @incident_report }
    end
  end

  # GET /incident_reports/1/edit
  def edit
    @incident_report = IncidentReport.find(params[:id])
  end

  # POST /incident_reports
  # POST /incident_reports.xml
  def create
    @incident_report = IncidentReport.new(params[:incident_report])
    @incident_report.type='IncidentReport'
    @incident_report.staff_id = current_staff.id
    @annotation = Annotation.new(params[:annotation])
    
    
    respond_to do |format|
      if @incident_report.save
      	@annotation.report_id = @incident_report.id
      	@annotation.save
        format.html { redirect_to(@incident_report, :notice => 'Incident report was successfully created.') }
        format.xml  { render :xml => @incident_report, :status => :created, :location => @incident_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @incident_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /incident_reports/1
  # PUT /incident_reports/1.xml
  def update
    @incident_report = IncidentReport.find(params[:id])

    respond_to do |format|
      if @incident_report.update_attributes(params[:incident_report])
        format.html { redirect_to(@incident_report, :notice => 'Incident report was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @incident_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /incident_reports/1
  # DELETE /incident_reports/1.xml
  def destroy
    @incident_report = IncidentReport.find(params[:id])
    @incident_report.destroy

    respond_to do |format|
      format.html { redirect_to(incident_reports_url) }
      format.xml  { head :ok }
    end
  end
  
  
  # GET /incident_reports/new_report
  # GET /incident_reports/new_report.xml
  def new_report
  	  self.new 
  end
  
end
