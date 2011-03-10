class IncidentReportsController < ApplicationController
  before_filter :admin_authorize, :except => [:new_report, :show, :edit]
  before_filter :general_authorize  
  autocomplete :student, :first_name, :display_value => :full_name
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
    
    # rkg why do you put annotation/infractins in session?
    # you can get them via indicent report already in session
    session[:annotation] = @annotation
   
    self.add_student_infractions_to_session
    session[:students] = nil
  end

  # POST /incident_reports
  # POST /incident_reports.xml
  def create
  	  # rkg what does this param mean? Answer: submitted from 
  	  if params[:search_submit] != nil
  	  	  @incident_report = session[:incident_report]
  	  	  @incident_report.approach_time = params[:incident_report][:approach_time]
  	  	  @incident_report.room_number = params[:incident_report][:room_number]
  	  	  @incident_report.building_id = params[:incident_report][:building_id]
  	  	  
  	  	  @annotation = Annotation.new
  	  	  @annotation.text = params[:annotation]
  	  	  
  	  	  self.add_student_infractions_to_session
  	  	  
  	  	  session[:incident_report] = @incident_report
  	  	  session[:annotation] = @annotation
 
  	  	  respond_to do |format|
  	  	  	  format.html { redirect_to '/search/report_search?/incident_reports/new_report' }
  	  	  	  format.xml  { render :xml => @incident_report, :status => :created, :location => @incident_report }
  	  	  	  format.iphone {render :layout => 'mobile_application'}
  	  	  end
  	  	  # rkg if search_submit is present do this...
  	  else
  	  	  @incident_report = session[:incident_report]
  	  	  
  	  	  #deal with annotations
  	  	  @annotation = session[:annotation]
  	  	  @annotation.text = params[:annotation]
  	  	  @annotation.save
  	  	  @incident_report.annotation_id = @annotation.id
  	  	  
  	  	  @incident_report.approach_time = params[:incident_report][:approach_time]
  	  	  @incident_report.room_number = params[:incident_report][:room_number]
  	  	  @incident_report.building_id = params[:incident_report][:building_id]
  	  	  
  	  	  respond_to do |format|
  	  	  	  if @incident_report.save
  	  	  	  	  self.add_reported_infractions_to_report(@incident_report, params)
  	  	  	  	  @incident_report.reported_infractions.each do |ri|
  	  	  	  	  	  if !ri.frozen?
  	  	  	  	  	  	  ri.incident_report_id = @incident_report.id
  	  	  	  	  	  	  ri.save
  	  	  	  	  	  end
  	  	  	  	  end
  	  	  	  	  
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
  	  if params[:save_submit] != nil
  	  	  @incident_report.submitted = false
	          @incident_report.save  	  	  
  	  end
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
  	  # rkg Can we do delete cascade for this?
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
  	  if session[:incident_report] == nil
  	  	  @incident_report = IncidentReport.new
  	  	  # rkg move to on_initialize; these are really arguments to constructor
  	  	  @incident_report.approach_time = Time.now
  	  	  @incident_report.staff_id = current_staff.id
  	  	  # rkg WTF?
  	  	  @incident_report.building_id = 16
  	  	  @annotation = Annotation.new
  	  	  # all above to on_initialize
    
  	  	  session[:incident_report] = @incident_report
  	  	  session[:annotation] = @annotation
  	  	  session[:students] = Array.new
  	  else
  	  	  @incident_report = session[:incident_report] 
  	  	  @annotation = session[:annotation]
  	  	  self.add_student_infractions_to_session
  	  end
  	  
  	  respond_to do |format|
  	  	  format.html # new_report.html.erb
  	  	  format.html  # rkg why twice?
  	  	  format.xml  { render :xml => @incident_report }
		  format.iphone {render :layout => 'mobile_application'}
  	  end 
  end
  
  
  
  
  def add_student_infractions_to_session
  	  # rkg this method is adding nothing to sessions
  	  # this code appears to be adding an RI of FYI to
  	  # a student appearing in IR. 
  	  # Looks more like update_participants_from_session?!
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
  	  	  	  	  
  	  	  	  	  # rkg WTF?
  	  	  	  	  newRI.infraction_id = 22 #fyi
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
  	  new_ris = Array.new
  	  old_ris = Array.new
  	  
  	  incident_report.reported_infractions.each do |ri|
  	  	  old_ris << ri
  	  end
  	  
  	  old_ris.sort! { |a, b|  a.participant.last_name <=> b.participant.last_name } 

  	  participants = Array.new
  	  
  	  if old_ris.count > 0
  	  	  curr_participant_id = old_ris.first.participant_id
  	  	  participants << curr_participant_id
  	  
  	  	  old_ris.each do |ri|
  	  	  	  if curr_participant_id != ri.participant_id
  	  	  	  	  curr_participant_id = ri.participant_id
  	  	  	  	  participants << curr_participant_id
  	  	  	  end
  	  	  end
  	  
  	  end
  	  
  	  participants.each do |p|
  	  	  something_found = false
  	  	  # rkg A database hit for each participant?
  	  	  infractions = Infraction.all
  	  	  infractions.each do |i|
  	  	  	  if params[p.to_s()] != nil && params[p.to_s()][i.id.to_s()] == "on"
  	  	  	  	  # try to find if reported_infraction already exists
  	  	  	  	  found = false
  	  	  	  	  old_ris.each do |ori|
  	  	  	  	  	  if found == false && ori.participant_id == p && ori.infraction_id == i.id 
  	  	  	  	  	  	  new_ris << ori
  	  	  	  	  	  	  #old_ris.delete(ori)
  	  	  	  	  	  	  found = true
  	  	  	  	  	  	  something_found = true
  	  	  	  	  	  end
  	  	  	  	  end
  	  	  	  	  if found == false
  	  	  	  	  	  ri = ReportedInfraction.new
  	  	  	  	  	  ri.participant_id = p
  	  	  	  	  	  ri.infraction_id = i.id
  	  	  	  	  	  new_ris << ri
  	  	  	  	  	  something_found = true
  	  	  	  	  end
  	  	  	  end
  	  	  end
  	  	  
  	  	  
  	  	  if something_found == false # no infractions were selected, add fyi
  	  	  	  ri = ReportedInfraction.new
  	  	  	  ri.participant_id = p
  	  	  	  # rkg WTF?
  	  	  	  ri.infraction_id = 22 #fyi
  	  	  	  new_ris << ri
  	  	  end
  	  end
  	  
  	  old_ris.each do |ori|
  	  	  if !new_ris.include?(ori)
  	  	  	  #old_ris.delete(ori)
  	  	  	  ori.incident_report_id = 0
  	  	  	  ori.destroy
  	  	  	  #ori = nil
  	  	  end
  	  end
  	  
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
  	 
  	  if params[:full_name].length > 3
  	  	  student = Student.get_student_object_for_string(params[:full_name])
  	  	  #@reported_infractions = ReportedInfraction.where(:participant_id => student.id)
  	  	  
  	  	  @reports = IncidentReport.where().includes(:reported_infractions).where(:participant_id => student.id)
  	  	  
  	  	  #@set_reports = Set.new
  	  	  
  	  	  #@reported_infractions.each do |ri|
  	  	  #	  @set_reports << IncidentReport.find(ri.incident_report_id)
  	  	  #end
  	  	  
  	  	  #@reports = Array.new

  	  	  #@set_reports.each do |ri|
  	  	  #	  @reports << ri
  	  	  #end
  	  end
  	  
  	  if params[:building_id] != "0" 
  	  	  if @reports != nil
  	  	  	  @reports = @reports.where(:building_id => params[:building_id])
  	  	  else	  
  	  	  	  @reports = IncidentReport.where(:building_id => params[:building_id])
  	  	  end
  	  end
  	 
  	
  	respond_to do |format|
  	  	  format.html # search.html.erb
  	end
  	  	  
  end
end
