class ReportsQueryController < ApplicationController
  
  before_filter :admin_assistant_authorize_view_access
  
  def reports_query
  end

   # GET /reports_query/
  def search    
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
      reported_inf = ReportParticipantRelationship.where(:participant_id => student.id)
      
      # get all of the report ids from the reported infractions
      reported_inf.each do |ri|
        report_ids << ri.report_id
      end
      
      # get the incident reports with those ids
      @reports = IncidentReport.where(:id => report_ids)
    end
    
    #-----------------
    # if a particular infraction was selected, get all reports w/ that infraction
    if !(params[:infraction_id].count == 1 && params[:infraction_id].include?("0"))
      # get reported infractions all with that infraction
      reported_inf = ReportParticipantRelationship.where(:infraction_id => params[:infraction_id])
      
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


