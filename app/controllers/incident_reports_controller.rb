class IncidentReportsController < ApplicationController
  before_filter :admin_assistant_authorize_view_access, :except => [:new_report, :show, :edit, :create, :update_participant_list, :update, :destroy]
  before_filter :not_admin_assistant_authorize_view_access, :except => [:show, :index]
  skip_before_filter :verify_authenticity_token
  acts_as_iphone_controller = true
  
  
  # GET /incident_reports
  # GET /incident_reports.xml
  def index
    self.clear_session #probably not necessary, 
    # but maybe "back" button was pushed on a new_report or edit page
    
    # get all submitted reports so view can display them (in order of approach time)
    @incident_reports = IncidentReport.where(:submitted => true).order(:approach_time)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incident_reports }
      format.iphone {render :layout => 'mobile_application'}
    end
  end
  
  
  
  
  
  
  # GET /incident_reports/1
  # GET /incident_reports/1.xml
  def show
    # get the report for the view to show
    @incident_report = IncidentReport.find(params[:id])
    
    if (@incident_report.submitted? && @incident_report.updated_at + 1.minutes < Time.now && current_staff.access_level == Authorize.ra_access_level) || (@incident_report.staff != current_staff && current_staff.access_level == Authorize.ra_access_level)
        flash[:notice] = "Unauthorized Access"
        redirect_to "/home/landingpage"
        return
    end
      
    
    self.clear_session #probably not necessary, but good practice anyway
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incident_report }
      #format.iphone {render :layout => false}
    end
  end
  
  
  
  
  
  
  # GET /incident_reports/1/edit
  def edit

      # get the report and annotation for the view to edit
      @incident_report = IncidentReport.find(params[:id])
      
      if (@incident_report.submitted? && current_staff.access_level == Authorize.ra_access_level) || (!@incident_report.submitted? && current_staff.access_level == Authorize.ra_access_level && @incident_report.staff != current_staff)
        flash[:notice] = "Unauthorized Access"
        redirect_to "/home/landingpage"
        return
      end
      
      @annotation = Annotation.find(@incident_report.annotation_id)
      
      # save the report and annotation into the session
      session[:incident_report] = @incident_report
      session[:annotation] = @annotation

    
    # if this is the return from a report_search page
    if session[:students] != nil
      @incident_report.add_default_report_student_relationships_for_participant_array(session[:students])
    end 
  end
  
  
  
  
  
  
  # POST /incident_reports
  # POST /incident_reports.xml
  def create

      # any submit button except search_submit (save_submit or submit_submit)
      @incident_report = session[:incident_report]
      
      # update annotation - save it this time
      @annotation = session[:annotation]
      @annotation.text = params[:annotation]
      @annotation.save
      @incident_report.annotation_id = @annotation.id
      
      # update other properties of incident report
      @incident_report.update_attributes_without_saving(params[:incident_report])
      
      # if user wants to submit report officially, set submitted to true
      if params[:submit_submit] != nil
        @incident_report.submitted = true
      end
      
      # process parameters into reported infractions
      self.add_reported_infractions_to_report(@incident_report, params)  
      
      # render next page, nothing else affects the view
      respond_to do |format|
        if @incident_report.save
          format.html { redirect_to(@incident_report, :notice => 'Incident report was successfully created.') }
          format.xml  { render :xml => @incident_report, :status => :created, :location => @incident_report }
          format.iphone {render :layout => 'mobile_application'}
        else
          format.html { render :action => "new_report" }
          format.xml  { render :xml => @incident_report.errors, :status => :unprocessable_entity }
          format.iphone { render :layout => 'mobile_application'}
        end
			end   
  end
  
  
  
  
  
  
  # PUT /incident_reports/1
  # PUT /incident_reports/1.xml
  def update
    # get the report to update
    @incident_report = IncidentReport.find(params[:id])
    

      #deal with annotations
      annotation = Annotation.find(@incident_report.annotation_id)
      annotation.text = params[:annotation]
      annotation.save
      
      # clear everything out of the session
      self.clear_session
      
      # process check boxes to update reported infractions
      self.add_reported_infractions_to_report(@incident_report, params)
      
      # if submit_submit button, submitted = true
      if params[:submit_submit] != nil
        @incident_report.submitted = true 
      end
      
      # show updated report
      respond_to do |format|
        if @incident_report.update_attributes(params[:incident_report])
          format.html { redirect_to(@incident_report, :notice => 'Incident report was successfully updated.') }
          format.xml  { head :ok }
          #format.iphone {render :layout => false}
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @incident_report.errors, :status => :unprocessable_entity }
          #format.iphone {render :layout => false} 
        end 	  	  	  
      end
   
    
  end
  
  
  
  
  
  
  # DELETE /incident_reports/1
  # DELETE /incident_reports/1.xml
  def destroy
    # get the report
    @incident_report = IncidentReport.find(params[:id])
    
    # check authorization
    if(Authorize.ra_authorize(current_staff) && current_staff != @incident_report.staff) || (Authorize.ra_authorize(current_staff) && current_staff == @incident_report.staff && @incident_report.submitted)
        flash[:notice] = "Unauthorized Access"
        redirect_to "/home/landingpage"
        return
    end
    
    # destroy all reported infractions associated with it
    @incident_report.report_participant_relationships.each do |ri|
      ri.destroy
    end
    
    # destroy the annotation
    Annotation.find(@incident_report.annotation_id).destroy
    
    # destroy the report
    @incident_report.destroy
    
    respond_to do |format|
      format.html { redirect_to(incident_reports_url) }
      format.xml  { head :ok }
      #format.iphone {render :layout => false}
    end
  end
  
  
  
  
  
  # GET /incident_reports/new_report
  # GET /incident_reports/new_report.xml
  def new_report 	 
  	  	  
  	  logger.debug "inside IR new_report"
      @incident_report = IncidentReport.new                # new report
      @incident_report.staff_id = current_staff.id         # set submitter
      @annotation = Annotation.new                         # new annotation
      
      #save everything to the session
      session[:incident_report] = @incident_report
      session[:annotation] = @annotation

   
    respond_to do |format|
      format.html # new_report.html.erb
      format.xml  { render :xml => @incident_report }
      format.iphone {render :layout => 'mobile_application'}
    end 
  end
  
  
  
  
  
  def clear_session
    # clear everything out of the sesson
    session[:incident_report] = nil
    session[:annotation] = nil
    session[:students] = nil
  end
  
  def add_reported_infractions_to_report(incident_report, params)
    # create arrays for the new reported infractions
    new_ris = Array.new
    old_ris = Array.new
    
    incident_report.report_participant_relationships.each do |ri|
      old_ris << ri
    end
    
    #create array for the participants we have
    participants = incident_report.get_all_participants
    
    # begin loop for each participant
    participants.each do |p|
      # variable to see if we have found an infraction for p
      any_relationship_to_report_found_for_participant = false 
      #loop through all infractions to see if user checked infraction for student
      RelationshipToReport.all.each do |i|
        # example: if the user wants student 6 to have infraction 1 (community disruption)
        # param entry would look like params[6][1] = "on"
        if params[p.to_s()] != nil && params[p.to_s()][i.id.to_s()] == "on"
          any_relationship_to_report_found_for_participant = true
          new_ris << incident_report.add_specific_relationship_to_report_for_participant(p, i.id)
        end
      end
      
      # if there are no checkboxes checked for particpant
      if any_relationship_to_report_found_for_participant == false
        new_ris << incident_report.add_default_relationship_to_report_for_participant(p)
      end
    end
    
    # destroy all old rep. inf.s if they are not in new list
    old_ris.each do |ori|
      if !new_ris.include?(ori)
        ori.report_id = 0 # make sure connection is broken
        ori.destroy
      end
    end
    
    # save new ris to report
    incident_report.report_participant_relationships = new_ris
    
  end
  
  # Callback for student search form
  def update_participant_list
  	@student = Student.get_student_object_for_string(params[:full_name])
  	@incident_report = session[:incident_report]
  	@incident_report.add_default_report_student_relationships_for_participant_array([ @student ])
  	respond_to do |format|
   	   format.js
   	end 
  end
  
end
  
  
  
 
