class IncidentReportsController < ApplicationController
  before_filter :admin_authorize, :except => [:new_report, :show, :edit]
  before_filter :general_authorize  
  skip_before_filter :verify_authenticity_token
  
  acts_as_iphone_controller = true
  
  # GET /incident_reports
  # GET /incident_reports.xml
  def index
    self.clear_session #probably not necessary, 
    # but maybe "back button" was pushed on a new_report or edit page
    
    @incident_reports = IncidentReport.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incident_reports }
      format.iphone {render :layout => 'mobile_application'}
    end
  end
  
  # GET /incident_reports/1
  # GET /incident_reports/1.xml
  def show
    @incident_report = IncidentReport.find(params[:id])
    @currentParticipantID = -1
    
    self.clear_session #probably not necessary, 
    # but maybe "back button" was pushed on a new_report or edit page
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incident_report }
      #format.iphone {render :layout => false}
    end
  end
  
  # GET /incident_reports/new
  # GET /incident_reports/new.xml
  
  # GET /incident_reports/1/edit
  def edit
    @incident_report = IncidentReport.find(params[:id])
    @annotation = Annotation.find(@incident_report.annotation_id)
    
    session[:incident_report] = @incident_report
    session[:annotation] = @annotation
    
    self.add_student_infractions_to_session
    session[:students] = nil
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
        # process paramters into reported infractions
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
    @incident_report = IncidentReport.find(params[:id])
    
    if params[:search_submit] != nil
      @annotation = Annotation.new
      @annotation.text = params[:annotation]
      
      session[:annotation] = @annotation
      session[:students] = nil
      
      self.add_reported_infractions_to_report(@incident_report, params)
      
      respond_to do |format|
        format.html { redirect_to '/search/report_search?/incident_reports/'+@incident_report.id.to_s()+'/edit/' }
        format.xml  { render :xml => @incident_report, :status => :created, :location => @incident_report }
        # format.iphone {render :layout => false}
      end
    else 
      #deal with annotations
      annotation = Annotation.find(@incident_report.annotation_id)
      annotation.update_text(params[:annotation])
      
      self.clear_session
      
      respond_to do |format|
        if @incident_report.update_attributes(params[:incident_report])
          self.add_reported_infractions_to_report(@incident_report, params)
          format.html { redirect_to(@incident_report, :notice => 'Incident report was successfully updated.') }
          format.xml  { head :ok }
          #format.iphone {render :layout => false}
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @incident_report.errors, :status => :unprocessable_entity }
        end
        #format.iphone {render :layout => false}  	  	  	  
      end
    end
    if params[:save_submit] != nil
      @incident_report.submitted = false
      @incident_report.save  	  	  
    end
    if params[:submit_submit] != nil
      @incident_report.submitted = true
      @incident_report.save  	  	  
    end
  end
  
  # DELETE /incident_reports/1
  # DELETE /incident_reports/1.xml
  def destroy
    @incident_report = IncidentReport.find(params[:id])
    
    @incident_report.reported_infractions.each do |ri|
      ri.destroy
    end
    
    Annotation.find(@incident_report.annotation_id).destroy
    
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
    @students = session[:students]
    
    if @students != nil
      @incident_report = session[:incident_report]
      
      @students.each do |s|
        exists = false
        @incident_report.reported_infractions.each do |ri|
          if s.id == ri.participant_id
            exists = true
          end
        end
        if exists == false
          newRI = ReportedInfraction.new
          newRI.participant_id = s.id
          newRI.infraction_id = Infraction.fyi #fyi
          @incident_report.reported_infractions << newRI
        end
      end
    end
  end
  
  
  def clear_session
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
  
  
  
  
  
  
  def save_annotation(incident_report, annot)
    if incident_report.annotation_id == nil
      annotation = Annotation.new
      annotation.text = annot
      annotation.save
      incident_report.annotation_id = annotation.id
    else
      annotation = Annotation.find(incident_report.annotation_id)
      annotation.text = annot
      incident_report.annotation_id = annotation.id
    end
  end
  
  
  
  # GET /incident_reports/search
  def search
    self.clear_session #probably not necessary, 
    # but good practice anyway.
    
    respond_to do |format|
      format.html # search.html.erb
    end
  end
  
  # POST /incident_reports/search_results
  def search_results
    @reports = nil
    report_ids = Array.new
    
    if params[:full_name].length > 3
      student = Student.get_student_object_for_string(params[:full_name])
      reported_inf = ReportedInfraction.where(:participant_id => student.id)
      
      reported_inf.each do |ri|
        report_ids << ri.incident_report_id
      end
      
      @reports = IncidentReport.where(:id => report_ids)
    end
    
    if !(params[:infraction_id].count == 1 && params[:infraction_id].include?("0"))
      reported_inf = ReportedInfraction.where(:infraction_id => params[:infraction_id])
      
      reported_inf.each do |ri|
        report_ids << ri.incident_report_id
      end
      
      @reports = IncidentReport.where(:id => report_ids)
    end
    
    if params[:building_id] != "0" 
      if @reports != nil
        @reports = @reports.where(:building_id => params[:building_id])
      else	  
        @reports = IncidentReport.where(:building_id => params[:building_id])
      end
    end
    
    if params[:area_id] != "0" 
      buildings = Building.where(:area_id => params[:area_id])
      if @reports != nil
        @reports = @reports.where(:building_id => buildings)
      else	  
        @reports = IncidentReport.where(:building_id => buildings)
      end
    end
    
    if params[:submitted_before] != "" 
      min = Time.parse("01/01/2000").gmtime
      max = Time.parse(params[:submitted_before]).gmtime
      if @reports != nil
        @reports = @reports.where(:approach_time => (min..max) )
      else	  
        @reports = IncidentReport.where(:approach_time => min..max )
      end
    end
    
    if params[:submitted_after] != "" 
      min = Time.parse(params[:submitted_after]).gmtime
      max = Time.now.gmtime
      if @reports != nil
        @reports = @reports.where(:approach_time => (min..max) )
      else	  
        @reports = IncidentReport.where(:approach_time => min..max )
      end
    end
    
    if @reports == nil
      @reports = IncidentReport.where(:submitted => true)
    else
      @reports = @reports.where(:submitted => true)
    end
    
    @reports = @reports.order(:approach_time)
    
    respond_to do |format|
      format.html # search.html.erb
    end
    
  end
end
