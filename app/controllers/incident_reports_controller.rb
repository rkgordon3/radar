class IncidentReportsController < ReportsController
  before_filter :admin_assistant_authorize_view_access, :except => [:new_report, :show, :edit, :create, :update_participant_list, :update, :destroy]
  before_filter :not_admin_assistant_authorize_view_access, :except => [:show, :index]
  skip_before_filter :verify_authenticity_token

  
  
  # GET /incident_reports
  # GET /incident_reports.xml
  def index
    self.clear_session #probably not necessary, 
    # but maybe "back" button was pushed on a new_report or edit page
    
    # get all submitted reports so view can display them (in order of approach time)
    @reports = IncidentReport.where(:submitted => true).order(:approach_time)
    
    #this was the previous it was changed because unsubmitted reports were submitted
    #@incident_reports = IncidentReport.where(:submitted => true).order(:approach_time)
    
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
  				logger.debug("IR create params = #{params}")
  		@report = session[:report]
   # process parameters into reported infractions
   		@report.add_reported_infractions(params)   
  		super
      
   
=begin     
      self.clear_session
      
      # render next page, nothing else affects the view
      respond_to do |format|
        if @report.save
			if @report.submitted == true
				Notification.immediate_notify(@report.id)
			end	
          format.html { redirect_to(@report, :notice => 'Incident report was successfully created.') }
          format.xml  { render :xml => @report, :status => :created, :location => @report }
          #format.iphone {render :layout => 'mobile_application'}
# TODO This may be a problem - rkg
          format.iphone {redirect_to(@report)}
        else
          format.html { render :action => "new_report" }
          format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
          format.iphone { render :action => "new_report", :layout => 'mobile_application'}
        end
			end 
=end
  end

  # PUT /incident_reports/1
  # PUT /incident_reports/1.xml
  def update
  				logger.debug("IR update")
  		@report = session[:report]
      # process check boxes to update reported infractions
      @report.add_reported_infractions(params)
# TODO This will be a problem submit_submit key no longer a param
# move notify to after_save
#      if params[:submit_submit] != nil
#    end
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
  
 
end
  
  
  
 
