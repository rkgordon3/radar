class IncidentReportsController < ReportsController
  
  before_filter :authenticate_staff!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource
  
  # POST /incident_reports
  # POST /incident_reports.xml
  def create
    @report = session[:report]
    super  
  end
  
  # PUT /incident_reports/1
  # PUT /incident_reports/1.xml
  def update
    @report = session[:report]  
    super
  end
  
  # GET /incident_reports/new
  # GET /incident_reports/new.xml
  def new
    @report = IncidentReport.new(:staff_id => current_staff.id)    # new report
    super
  end

  def index
    @report = @incident_report
    super
  end

  def show
    @report = @incident_report
    super
  end

  def edit
    @report = @incident_report
    super
  end

  def destroy
    @report = @incident_report
    super
  end
  
end




