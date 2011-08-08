class ShiftsController < ApplicationController
  before_filter :authenticate_staff!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource
  
  
  def index
    all_logs = false
    if params[:access_level] == "Any"
      #don't filter shifts
      all_logs = true

    elsif params[:access_level] != nil
      @shifts = @shifts.joins(:staff => :access_level ).where("access_levels.name = ?", params[:access_level])
      access_level = AccessLevel.find_by_name(params[:access_level])
      log_type = access_level.log_type
      access_level = access_level.display_name
    end

    if params[:staff_id] != nil
      @shifts = @shifts.where(:staff_id => params[:staff_id])
    end
    @shifts = Shift.sort(@shifts,params[:sort])
    @numRows = 0
    
    
    respond_to do |format|
      format.html { render :locals => { :shifts => @shifts, :access_level => access_level, :log_type => log_type, :all_logs => all_logs } }
      format.xml  { render :xml => @shifts }
    end
  end
  
  # GET /shifts/new
  # GET /shifts/new.xml
  def new
    # @shifts automatically loaded by CanCan
  end
  
  # GET /shifts/1/edit
  def edit
    # @shifts automatically loaded by CanCan
  end
  
  # POST /shifts
  # POST /shifts.xml
  def create
    @shift.area_id = current_staff.staff_areas.first.area.id
    @shift.annotation = Annotation.new(:text => params[:annotation][:text])
    # unless the following 2 commands are executed, the time is saved in the wrong time zone
    @shift.created_at = @shift.created_at.advance({:hours=>0})
    @shift.time_out = @shift.time_out.advance({:hours=>0})
    # can't understand why... but had to do it for tasks as well

    respond_to do |format|
      if @shift.save
        format.html { redirect_to({:action => "#{@shift.staff.access_level.log_type}_log", :controller => 'shifts', :id => @shift}, :notice => 'Shift was successfully created.') }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shift.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /shifts/1
  # PUT /shifts/1.xml
  def update
    # @shift automatically loaded by CanCan
    params[:shift] ||= Hash.new
    params[:shift][:time_out] ||= Time.now
    params[:shift][:annotation] = params[:annotation][:text]

    round = Round.where(:end_time => nil, :shift_id => @shift.id).first
    if round != nil
      round.end_time = Time.now
      round.save
      @notice = "You are now off a round and off duty."
    else
      @notice = "Your shift has been updated."
    end

    if !@shift.tasks_completed?
      @notice = @notice + "..but some tasks were not completed!"
    end

    
    respond_to do |format|
      if @shift.update_attributes(params[:shift])
        format.html { redirect_to({:action => "#{@shift.staff.access_level.log_type}_log", :controller => 'shifts', :id => @shift.id}, :notice => @notice) }
        format.js { render 'shifts/end_shift' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shift.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /shifts/1
  # DELETE /shifts/1.xml
  def destroy
    @shift.destroy
    
    respond_to do |format|
      format.html { redirect_to(shifts_url) }
      format.xml  { head :ok }
    end
  end
  
  def start_shift
    @shift = current_staff.current_shift
    if !current_staff.on_duty?
      area_id = current_staff.staff_areas.first.area_id
      @shift = Shift.new(:staff_id => current_staff.id, :area_id => area_id)
    
      Task.get_active_by_area(area_id).each do |task|
        @shift.assign_task(task)
      end
    
      @shift.save
      @task_assignments = TaskAssignment.where(:shift_id => @shift.id)
    
      respond_to do |format|
        format.js
      end
    end
  end

  def call_log
    #RA shifts included in HD call logs are defined as ones that ended while the HD was on duty
    ra_shifts = Shift.joins(:staff => :access_level ).where("access_levels.name = ?", "ResidentAssistant")
    ra_shifts = ra_shifts.where("time_out >= ? AND time_out < ?", @shift.created_at, @shift.time_out)
    ra_shift_ids = Array.new
    ra_shifts.each do |ra_shift|
      ra_shift_ids << ra_shift.id
    end
    reports = Report.where(:created_at => @shift.created_at..@shift.time_out, :submitted=> true)
    total_reports = reports.length
    total_incident_reports = reports.where(:type => "IncidentReport").length
    notes = reports.where(:type => "Note")
    notes = Report.sort(notes,params[:sort])
    reports = reports.where(:type=>["IncidentReport","MaintenanceReport"])
    reports = Report.sort(reports,params[:sort])

    @task_assignments = TaskAssignment.where(:shift_id => ra_shift_ids)
    total_incomplete_task_assignments = @task_assignments.where(:done => false).length
    @task_assignments = TaskAssignment.sort(@task_assignments, params[:sort_tasks])
    
    respond_to do |format|
      format.html { render :locals => { :total_incident_reports => total_incident_reports, :reports => reports, :total_reports => total_reports, :total_incomplete_task_assignments => total_incomplete_task_assignments, :notes => notes } }
      format.xml  { render :locals => { :total_incident_reports => total_incident_reports, :reports => reports, :total_reports => total_reports, :total_incomplete_task_assignments => total_incomplete_task_assignments, :notes => notes } }
      format.js   { render :locals => { :reports => reports, :notes => notes } }
    end

  end
  
  def duty_log
    @rounds = Round.where("shift_id = ?",params[:id]).order(:end_time)
    @task_assignments = TaskAssignment.where(:shift_id => @shift.id)
    total_incomplete_task_assignments = @task_assignments.where(:done => false).length

    on_round_report_map ||= Hash.new
    on_round_note_map ||= Hash.new
    off_round_reports ||= Array.new
    off_round_notes ||= Array.new
    round_time_end = @shift.created_at
    total_reports = 0

    @rounds.each do |round|
      round_time_start = round.created_at

      off_round_reps = Report.where(:staff_id=>@shift.staff_id, :created_at => round_time_end..round_time_start, :submitted=> true)
      off_round_reports += off_round_reps.where(:type=>["IncidentReport","MaintenanceReport"])
      off_round_notes += off_round_reps.where(:type => "Note")
      round_time_end = round.end_time
      reports = Report.where(:staff_id=>@shift.staff_id, :created_at => round_time_start..round_time_end, :submitted=> true)
      total_reports += reports.length
      notes = reports.where(:type => "Note")
      notes = Report.sort(notes,params[:sort])
      reports = reports.where(:type=>["IncidentReport","MaintenanceReport"])
      reports = Report.sort(reports,params[:sort])
      on_round_report_map[round] = reports
      on_round_note_map[round] = notes
    end

    off_round_reports += Report.where(:staff_id=>@shift.staff_id, :created_at => round_time_end..@shift.time_out, :submitted=> true)
    total_reports += off_round_reports.length
    total_reports += off_round_notes.length

    # off_round_reports = Report.sort(off_round_reports,params[:sort]) <<<<==== Report.sort does not work with Array class TODO: make off_round_reports instance of ActiveRecord::Relation class
    
    respond_to do |format|
      format.html { render :locals => { :on_round_report_map => on_round_report_map, :on_round_note_map => on_round_note_map, :total_reports => total_reports, :total_incomplete_task_assignments => total_incomplete_task_assignments, :off_round_notes => off_round_notes, :off_round_reports => off_round_reports } }
      format.xml  { render :locals => { :on_round_report_map => on_round_report_map, :on_round_note_map => on_round_note_map, :total_reports => total_reports, :total_incomplete_task_assignments => total_incomplete_task_assignments, :off_round_notes => off_round_notes, :off_round_reports => off_round_reports } }
      format.js   { render :locals => { :on_round_report_map => on_round_report_map, :on_round_note_map => on_round_note_map, :off_round_reports => off_round_reports, :off_round_notes => off_round_notes } }
    end
  end
  
  def end_shift
    logger.debug "***********ending shift***********"
    @shift = current_staff.current_shift
    total_incomplete_task_assignments = TaskAssignment.where(:shift_id => @shift.id).where(:done => false).length
    
    respond_to do |format|
      format.html {render :locals => {:total_incomplete_task_assignments => total_incomplete_task_assignments}}
    end
  end
end
  
def update_todo
  task_list = params[:task]
  TaskAssignment.where(:shift_id => current_staff.current_shift.id).each do | assignment |
    assignment.done = task_list[assignment.id.to_s] != nil
    assignment.save
  end
  
  respond_to do |format|
    format.iphone { render :nothing => true }
  end
end
