class IncidentReportsController < ApplicationController
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
    @annotation = Annotation.find(@incident_report.annotation_id)
    
    # save the report and annotation into the session
    session[:incident_report] = @incident_report
    session[:annotation] = @annotation
    
    # if this is the return from a report_search page
    if session[:students] != nil
      self.add_student_infractions_to_session
      session[:students] = nil
    end 
  end
  
  
  
  
  
  
  # POST /incident_reports
  # POST /incident_reports.xml
  def create
    #search_submit is name of button clicked called "add students"
    if params[:search_submit] != nil
      # update values of incident_report
      @incident_report = session[:incident_report]
      @incident_report.approach_time = params[:incident_report][:approach_time]
      @incident_report.room_number = params[:incident_report][:room_number]
      @incident_report.building_id = params[:incident_report][:building_id]
      
      # update annotation
      @annotation = session[:annotation]
      @annotation.text = params[:annotation]
      
      # render search page, sending own path as return address
      respond_to do |format|
        format.html { redirect_to '/search/report_search?/incident_reports/new_report' }
        format.xml  { render :xml => @incident_report, :status => :created, :location => @incident_report }
        format.iphone {render :layout => 'mobile_application'}
      end
      
      # any submit button except search_submit (save_submit or submit_submit)
    else
      @incident_report = session[:incident_report]
      
      # update annotation - save it this time
      @annotation = session[:annotation]
      @annotation.text = params[:annotation]
      @annotation.save
      @incident_report.annotation_id = @annotation.id
      
      # update other properties of incident report
      @incident_report.approach_time = params[:incident_report][:approach_time]
      @incident_report.room_number = params[:incident_report][:room_number]
      @incident_report.building_id = params[:incident_report][:building_id]
      
      # save incident report in database
      saved = false
      if @incident_report.save #returns true if successful
        # process parameters into reported infractions
        self.add_reported_infractions_to_report(@incident_report, params)
        # save each reported infraction to database
        @incident_report.reported_infractions.each do |ri|
          if !ri.frozen?                                # make sure the reported infraction isn't frozen
            ri.incident_report_id = @incident_report.id # establish connection
            ri.save                                     # actually save
          end
        end
        saved = true # saving was successful
      end 
      
      # render next page, nothing else affects the view
      respond_to do |format|
        if saved == true
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
    
    # if user only wants to save report, not submit, set submitted to false
    if params[:save_submit] != nil
      @incident_report.submitted = false
      @incident_report.save  	  	  
    end
    
    # if user wants to submit report, set submitted to true
    if params[:submit_submit] != nil
      @incident_report.submitted = true
      @incident_report.save  	  	  
    end
  end
  
  
  
  
  
  
  # PUT /incident_reports/1
  # PUT /incident_reports/1.xml
  def update
    # get the report to update
    @incident_report = IncidentReport.find(params[:id])
    
    # if search_submit button was clicked, save history
    if params[:search_submit] != nil
      @annotation = session[:annotation]
      @annotation.text = params[:annotation]
      @annotation.save
      
      # make sure students array in session is empty
      session[:students] = nil
      
      # if user changed infractions for participants, save changes
      self.add_reported_infractions_to_report(@incident_report, params)
      
      # go to report_search page, using current page as request parameter
      respond_to do |format|
        format.html { redirect_to '/search/report_search?/incident_reports/'+@incident_report.id.to_s()+'/edit/' }
        format.xml  { render :xml => @incident_report, :status => :created, :location => @incident_report }
        # format.iphone {render :layout => false}
      end
    else 
      #deal with annotations
      annotation = Annotation.find(@incident_report.annotation_id)
      annotation.text = params[:annotation]
      annotation.save
      
      # clear everything out of the session
      self.clear_session
      
      # process check boxes to update reported infractions
      self.add_reported_infractions_to_report(@incident_report, params)
      
      # if save_submit button, then submitted = false
      if params[:save_submit] != nil
        @incident_report.submitted = false
        @incident_report.save         
      end
      
      # if submit_submit button, submitted = true
      if params[:submit_submit] != nil
        @incident_report.submitted = true
        @incident_report.save         
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
    
  end
  
  
  
  
  
  
  # DELETE /incident_reports/1
  # DELETE /incident_reports/1.xml
  def destroy
    # get the report
    @incident_report = IncidentReport.find(params[:id])
    
    # destroy all reported infractions associated with it
    @incident_report.reported_infractions.each do |ri|
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
    # incident_report in session will be nil if first visit to page
    if session[:incident_report] == nil
      @incident_report = IncidentReport.new                # new report
      @incident_report.approach_time = Time.now            # set approach time
      @incident_report.staff_id = current_staff.id         # set submitter
      @incident_report.building_id = Building.unspecified  # building = unspecified
      @annotation = Annotation.new                         # new annotation
      
      #save everything to the session
      session[:incident_report] = @incident_report
      session[:annotation] = @annotation
      session[:students] = Array.new
      
      # if incident report in session is not nil (not first visit)
    else
      # add students returned by search to report by creating fyi infractions
      self.add_student_infractions_to_session              
    end
    
    respond_to do |format|
      format.html # new_report.html.erb
      format.xml  { render :xml => @incident_report }
      format.iphone {render :layout => 'mobile_application'}
    end 
  end
  
  
  
  
  
  
  def add_student_infractions_to_session
    # get students from session (added from search controller)
    @students = session[:students]
    
    if @students != nil
      # get the incident report from the session
      @incident_report = session[:incident_report]
      
      # go through the students to see if we need to add an fyi infraction
      @students.each do |s|
        exists = false
        # search to see if an RI exists already for that student
        @incident_report.reported_infractions.each do |ri|
          if s.id == ri.participant_id
            exists = true
          end
        end
        # if infraction was not found, create FYI RI for student
        if exists == false
          newRI = ReportedInfraction.new
          newRI.participant_id = s.id
          newRI.infraction_id = Infraction.fyi #fyi
          # add new RI to the report
          @incident_report.reported_infractions << newRI
        end
      end
    end
  end
  
  
  
  
  
  
  
  def clear_session
    # clear everything out of the sesson
    session[:incident_report] = nil
    session[:annotation] = nil
    session[:students] = nil
  end
  
  
  
  
  
  def add_reported_infractions_to_report(incident_report, params)
    # create arrays for the new reported infractions and the old ones
    new_ris = Array.new
    old_ris = Array.new
    
    # populate the old reported infractions array with the report's infractions
    incident_report.reported_infractions.each do |ri|
      old_ris << ri
    end
    
    # sort the infractions so all infractions by same student are grouped
    old_ris.sort! { |a, b|  a.participant.last_name <=> b.participant.last_name } 
    
    #create array for the participants we have
    participants = Array.new
    
    # if we have more than one old reported infraction
    if old_ris.count > 0
      # search for unique participants and save ids
      curr_participant_id = old_ris.first.participant_id
      participants << curr_participant_id
      
      old_ris.each do |ri|
        if curr_participant_id != ri.participant_id
          curr_participant_id = ri.participant_id
          participants << curr_participant_id
        end
      end # end loop
    end # end if more than one old reported infraction
    
    # begin loop for each participant
    participants.each do |p|
      # variable to see if we have found an infraction for p
      something_found = false 
      #loop through all infractions to see if user checked infraction for student
      infractions = Infraction.all
      infractions.each do |i|
        # example: if the user wants student 6 to have infraction 1 (comm. disrupt)
        # param entry would look like params[6][1] = "on"
        if params[p.to_s()] != nil && params[p.to_s()][i.id.to_s()] == "on"
          # try to find if reported_infraction already exists
          found = false # var to see if rep. inf. already exists
          old_ris.each do |ori|
            if found == false && ori.participant_id == p && ori.infraction_id == i.id 
              new_ris << ori # add old rep. inf. to new list
              found = true # found already existing rep. inf
              something_found = true # found soemthing for particpant
            end 
          end
          
          # if haven't found anything, create new rep. inf.
          if found == false
            ri = ReportedInfraction.new
            ri.participant_id = p
            ri.infraction_id = i.id
            new_ris << ri # add new rep. inf to new list
            something_found = true # found soemthing for particpant
          end
        end
      end # end participant loop
      
      
      if something_found == false # no infractions were selected, add fyi
        ri = ReportedInfraction.new
        ri.participant_id = p
        ri.infraction_id = Infraction.fyi # fyi index
        new_ris << ri # add new rep. inf to new list
      end
    end
    
    # destroy all old rep. inf.s if they are not in new list
    old_ris.each do |ori|
      if !new_ris.include?(ori)
        ori.incident_report_id = 0 # make sure connection is broken
        ori.destroy
      end
    end
    
    # add all the current reported infractions to the incident report
    new_ris.each do |nri|
      incident_report.reported_infractions << nri
    end
  end
  
  
  
  
  
  # GET /incident_reports/search
  def search
    self.clear_session #probably not necessary, but good practice anyway.
    
    respond_to do |format|
      format.html # search.html.erb
    end
  end
  
  
  
  
  
  
  # POST /incident_reports/search_results
  def search_results
    @reports = nil
    report_ids = Array.new
    student = nil
    
    # if a student's name was entered, find all reports with that student
    if params[:full_name].length > 3 # arbitrary number
      # get the student for the string entered
      student = Student.get_student_object_for_string(params[:full_name])
      
      # get all reported infractions for that student
      reported_inf = ReportedInfraction.where(:participant_id => student.id)
      
      # get all of the report ids from the reported infractions
      reported_inf.each do |ri|
        report_ids << ri.incident_report_id
      end
      
      # get the incident reports with those ids
      @reports = IncidentReport.where(:id => report_ids)
    end
    
    #-----------------
    # if a particular infraction was selected, get all reports w/ that infraction
    if !(params[:infraction_id].count == 1 && params[:infraction_id].include?("0"))
      # get reported infractions all with that infraction
      reported_inf = ReportedInfraction.where(:infraction_id => params[:infraction_id])
      
      # if a student was selected, limit to only those infractions by that student
      if student != nil
        reported_inf = reported_inf.where(:participant_id => student.id)
        report_ids = Array.new
      end
      
      # collect the report_ids from the reported infractions into an array
      reported_inf.each do |ri|
        report_ids << ri.incident_report_id
      end
      
      # get the reports with ids in the array
      @reports = IncidentReport.where(:id => report_ids)
    end
    
    #----------------
    # if no student or infraction was selected, select all 
    if @reports == nil
      @reports = IncidentReport.where(:submitted => true)
    end
    
    
    #-----------------
    # if a building was selected, get reports in that building
    if params[:building_id] != "0" 
      @reports = @reports.where(:building_id => params[:building_id])
    end
    
    #-----------------
    # if an area was selected, get reports in that area
    if params[:area_id] != "0" 
      buildings = Building.where(:area_id => params[:area_id])
      @reports = @reports.where(:building_id => buildings)
      
    end
    
    #-----------------
    # if a date was provided, find all before that date
    if params[:submitted_before] != "" 
      # all incident reports should take place in this century
      # be careful of time zones - all need to be in GMT to match the DB
      min = Time.parse("01/01/2000").gmtime
      max = Time.parse(params[:submitted_before]).gmtime
      
      @reports = @reports.where(:approach_time => min..max )
    end
    
    #-----------------
    # if a date was provided, find all after that date
    if params[:submitted_after] != "" 
      # all incident reports should take place before right now (ignoring daylight savings)
      # be careful of time zones - all need to be in GMT to match the DB
      min = Time.parse(params[:submitted_after]).gmtime
      max = Time.now.gmtime
      
      @reports = @reports.where(:approach_time => min..max )
    end
    
    
    # finishing touches...
    @reports = @reports.where(:submitted => true)    
    @reports = @reports.order(:approach_time)
    
    respond_to do |format|
      format.html # search.html.erb
    end
    
  end
end
