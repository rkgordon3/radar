class IncidentReportsController < ReportsController
  
  before_filter :authenticate_staff!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource
  
  
  
  # GET /incident_reports
  # GET /incident_reports.xml
  def index
    self.clear_session #probably not necessary, 
    # but maybe "back" button was pushed on a new report or edit page
    
    # get all submitted reports so view can display them (in order of approach time)
    @reports = IncidentReport.where(:submitted => true, :approach_time => Time.now - 30.days .. Time.now)
    @reports=Report.sort(@reports,params[:sort])
    respond_to do |format|
      format.html { render :locals => { :reports => @reports } }
      format.xml  { render :xml => @reports }
      format.iphone {render :layout => 'mobile_application'}
    end
  end
  
  
  # POST /incident_reports
  # POST /incident_reports.xml
  def create
    @report = session[:report]
    # process parameters into reported infractions
    @report.add_contact_reason(params)   
    super  
  end
  
  # PUT /incident_reports/1
  # PUT /incident_reports/1.xml
  def update
    @report = session[:report]
    # process check boxes to update reported infractions
    @report.add_contact_reason(params)   
    super
  end
  
  
  # DELETE /incident_reports/1
  # DELETE /incident_reports/1.xml
  def destroy
    # get the report
    @report = IncidentReport.find(params[:id])
    # destroy the report
    @report.destroy
    
    respond_to do |format|
      format.html { redirect_to(reports_url) }
      format.xml  { head :ok }
      #format.iphone {render :layout => false}
    end
  end
  
  # GET /incident_reports/new
  # GET /incident_reports/new.xml
  def new
    @report = IncidentReport.new(:staff_id => current_staff.id)    # new report
    @report.process_participant_params_string_from_student_search(params[:participants])
    super
  end
  
  def clear_session
    # clear everything out of the session
    session[:report] = nil
  end
  
end




