class IncidentReportsController < ReportsController
  
  before_filter :authenticate_staff!
  before_filter :admin_assistant_authorize_view_access, :except => [:new, :show, :edit, :create, :update, :destroy]
  before_filter :not_admin_assistant_authorize_view_access, :except => [:show, :index]
  skip_before_filter :verify_authenticity_token
  
  
  
  # GET /incident_reports
  # GET /incident_reports.xml
  def index
    self.clear_session #probably not necessary, 
    # but maybe "back" button was pushed on a new report or edit page
    
    # get all submitted reports so view can display them (in order of approach time)
    @reports = IncidentReport.where(:submitted => true)
    @reports=Report.sort(@reports,params[:sort])
    
    respond_to do |format|
      format.html { render :locals => { :reports => @reports } }
      format.xml  { render :xml => @reports }
      format.iphone {render :layout => 'mobile_application'}
    end
  end
  

  
  
  # GET /incident_reports/1
  # GET /incident_reports/1.xml
  
  def show
    # get the report for the view to show
    @report = IncidentReport.find(params[:id])
    
    if (@report.submitted? && @report.updated_at + 1.minutes < Time.now && current_staff.access_level == Authorize.ra_access_level) || (@report.staff != current_staff && current_staff.access_level == Authorize.ra_access_level)
      flash[:notice] = "Unauthorized Access"
      redirect_to "/home/landingpage"
      return
    end
    
    
    self.clear_session #probably not necessary, but good practice anyway
    
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @report }
      #format.iphone {render :layout => false}
      format.iphone {render :layout => 'mobile_application'}
    end
  end
  
  # GET /incident_reports/1/edit
  def edit
    
    # get the report and annotation for the view to edit
    @report = IncidentReport.find(params[:id])
    
    if (@report.submitted? && current_staff.access_level == Authorize.ra_access_level) || (!@report.submitted? && current_staff.access_level == Authorize.ra_access_level && @report.staff != current_staff)
      flash[:notice] = "Unauthorized Access"
      redirect_to "/home/landingpage"
      return
    end
    
    # save the report and annotation into the session
    session[:report] = @report
    
    
    respond_to do |format|
      format.html 
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
    logger.debug("IR update")
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
    
    # check authorization
    if(Authorize.ra_authorize(current_staff) && current_staff != @report.staff) || (Authorize.ra_authorize(current_staff) && current_staff == @report.staff && @report.submitted)
      flash[:notice] = "Unauthorized Access"
      redirect_to "/home/landingpage"
      return
    end
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
    
    @report = IncidentReport.new(:staff_id => current_staff.id)               # new report
    
    @report.process_participant_params_string_from_student_search(params[:participants])
    
    session[:report] = @report
    
    # logger.debug "in new report, these are my session saved reported infractions " 
    # logger.debug session[:report].report_participant_relationships
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
      format.iphone {render :layout => 'mobile_application'}
    end 
    return
  end
  
  
  def clear_session
    # clear everything out of the sesson
    session[:report] = nil
  end
 
  def unsubmitted_index
	super
  end
  
  
end




