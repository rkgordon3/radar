class MaintenanceReportsController < ReportsController
  load_and_authorize_resource
  
  def new
    @report = MaintenanceReport.new(:staff_id => current_staff.id)
    @report.process_participant_params_string_from_student_search(params[:participants])
    super
  end
  
  # GET /incident_reports
  # GET /incident_reports.xml
  def index
    @reports = MaintenanceReport.where(:submitted => true, :approach_time => Time.now - 30.days .. Time.now)
    @reports = Report.sort(@reports,params[:sort])
    
    respond_to do |format|
      format.html { render :locals => { :reports => @reports } }
      format.xml  { render :xml => @reports }
      format.iphone {render :layout => 'mobile_application'}
    end
  end
end
