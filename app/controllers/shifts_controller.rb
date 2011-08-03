class ShiftsController < ApplicationController
  before_filter :authenticate_staff!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource
  
  
  def index
    @shifts = Shift.sort(Shift,params[:sort])
    @numRows = 0
    
    respond_to do |format|
      format.html { render :locals => { :shifts => @shifts } }
      format.xml  { render :xml => @shifts }
    end
  end
  
  # GET /shifts/1
  # GET /shifts/1.xml
  def show
    respond_to do |format|
      
      format.html # show.html.erb
      format.xml  { render :xml => @shift }
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
    respond_to do |format|
      if @shift.save
        format.html { redirect_to(@shift, :notice => 'Shift was successfully created.') }
        format.xml  { render :xml => @shift, :status => :created, :location => @shift }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shift.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /shifts/1
  # PUT /shifts/1.xml
  def update
    # @report_type automatically loaded by CanCan
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
    if current_staff.on_duty?
      @shift = Shift.where(:staff_id => current_staff.id, :time_out => nil).first
      if @shift == nil
        return
      end
      @shift.time_out = Time.now
      @shift.save
      @round = Round.where(:end_time => nil, :shift_id => @shift.id).first
      if @round != nil
        @round.end_time = Time.now
        @round.save
        @notice = "You are now off a round and off duty."
      else
        @notice = "You are now off duty."
      end
	
      if !@shift.tasks_completed?
        @notice = @notice + "...but some tasks were not completed!"
      end
    
      respond_to do |format|
        format.js
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
  
end
