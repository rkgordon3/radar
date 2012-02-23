class IncidentReportsController < ReportsController
  
  before_filter :authenticate_staff!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource
  

  # GET /incident_reports/new
  # GET /incident_reports/new.xml
  def new
    @report = IncidentReport.new(:staff_id => current_staff.id)    # new report
    super
  end
end




