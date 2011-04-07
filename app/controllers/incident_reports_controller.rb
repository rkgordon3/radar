class IncidentReportsController < ReportsController
  before_filter :admin_authorize, :except => [:new_report, :show, :edit]
  before_filter :general_authorize  
  skip_before_filter :verify_authenticity_token
  acts_as_iphone_controller = true
  
  
  # GET /incident_reports
  # GET /incident_reports.xml
  def index
    self.clear_session #probably not necessary, 
    # but maybe "back" button was pushed on a new_report or edit page
    
    # get all submitted reports so view can display them (in order of approach time)
    @reports = IncidentReport.where(:submitted => true).order(:approach_time)
    
    respond_to do |format|
    	format.html { render :locals => { :reports => @reports } }
      format.xml  { render :xml => @reports }
      format.iphone {render :layout => 'mobile_application'}
    end
  end

  # GET /incident_reports/1
  # GET /incident_reports/1.xml
=begin
  def show
    # get the report for the view to show
    @report = IncidentReport.find(params[:id])
    
    self.clear_session #probably not necessary, but good practice anyway
    
   
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @report }
      #format.iphone {render :layout => false}
    end
  end
=end
  
  
  
  
  
  
  # GET /incident_reports/1/edit
  def edit
  				logger.debug ("IN EDIT INCIDENT_CONTROLLER")
    if(session[:report] !=nil)
      @report = session[:report]
    else
      # get the report and annotation for the view to edit
      @report = IncidentReport.find(params[:id])
      # save the report and annotation into the session
      session[:report] = @report
    end
  end

  
  # POST /incident_reports
  # POST /incident_reports.xml
  def create
  		@report = session[:report]
   # process parameters into reported infractions
   		@report.add_reported_infractions(params)   
  		super
      
   
=begin     
      # render next page, nothing else affects the view
      respond_to do |format|
        if @report.save
          format.html { redirect_to(@report, :notice => 'Incident report was successfully created.') }
          format.xml  { render :xml => @report, :status => :created, :location => @report }
          format.iphone {render :layout => 'mobile_application'}
        else
          format.html { render :action => "new_report" }
          format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
          format.iphone { render :layout => 'mobile_application'}
        end
			end 
=end
  end

  # PUT /incident_reports/1
  # PUT /incident_reports/1.xml
  def update
  		@report = session[:report]
      # process check boxes to update reported infractions
      @report.add_reported_infractions(params)
      self.clear_session
      super

=begin
      respond_to do |format|
        if @report.update_attributes(params[:report])
          format.html { redirect_to(@report, :notice => 'Incident report was successfully updated.') }
          format.xml  { head :ok }
          #format.iphone {render :layout => false}
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
          #format.iphone {render :layout => false} 
        end 	  	  	  
      end
=end
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
  
  
  # GET /incident_reports/new_report
  # GET /incident_reports/new_report.xml
  def new_report 	 
  	  	  
  	logger.debug "inside IR new_report"

 		@report = IncidentReport.new(:staff_id => current_staff.id)               # new report
    session[:report] = @report

    respond_to do |format|
      format.html # new_report.html.erb
      format.xml  { render :xml => @report }
      format.iphone {render :layout => 'mobile_application'}
    end 
  end
  
  
  def clear_session
    # clear everything out of the sesson
    session[:report] = nil
  end
  
 
  # Callback for student search form
  def update_participant_list
  	student = Student.get_student_object_for_string(params[:full_name])
  	@report = session[:report]
  	@report.add_default_report_student_relationships_for_participant_array([ student ])
  	respond_to do |format|
   	   format.js 
   	end 
  end
end
  
  
  
 
