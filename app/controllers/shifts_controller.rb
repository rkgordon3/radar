class ShiftsController < ApplicationController
  
  
  
  # GET /shifts
  # GET /shifts.xml
  helper_method :report_map
  helper_method :note_map
  before_filter :authenticate_staff!
  before_filter :ra_authorize_view_access
  skip_before_filter :verify_authenticity_token
  
  
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
    @shift = Shift.find(params[:id])
    
    
    respond_to do |format|
      
      format.html # show.html.erb
      format.xml  { render :xml => @shift }
    end
  end
  
  # GET /shifts/new
  # GET /shifts/new.xml
  def new
    #@shift = Shift.new(:staff_id => current_staff.id)
    
    #redirect_to request.path_parameters
    #respond_to do |format|
    # format.html # new.html.erb
    #format.xml  { render :nothing => true }
    #end
  end
  
  # GET /shifts/1/edit
  def edit
    @shift = Shift.find(params[:id])
  end
  
  # POST /shifts
  # POST /shifts.xml
  def create
    @shift = Shift.new(params[:shift])
    
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
    @shift = Shift.find(params[:id])
    
    #respond_to do |format|
    # if @shift.update_attributes(params[:shift])
    #  format.html { redirect_to(@shift, :notice => 'Shift was successfully updated.') }
    # format.xml  { head :ok }
    #else
    #  format.html { render :action => "edit" }
    # format.xml  { render :xml => @shift.errors, :status => :unprocessable_entity }
    #end
    #end
  end
  
  # DELETE /shifts/1
  # DELETE /shifts/1.xml
  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy
    
    respond_to do |format|
      format.html { redirect_to(shifts_url) }
      format.xml  { head :ok }
    end
  end
  
  def start_shift
    @shift = Shift.new(:staff_id => current_staff.id)
    Task.all.each do |task|
      @shift.add_task(task)
    end
    @shift.save
    
    respond_to do |format|
      format.js
    end
  end
  
  def duty_log
    
    @shift = Shift.find(params[:id])
    @rounds = Round.where("shift_id = ?",params[:id]).order(:end_time)
    round_time_start = @shift.created_at
    @task_assignments = TaskAssignment.where(:shift_id => @shift.id)
    @rounds.each do |round|
      round_time_end=round.end_time
      report=Report.where(:staff_id=>@shift.staff_id, :approach_time => round_time_start..round_time_end, :submitted=> true)
      note=report.where(:type=>"Note").order(:approach_time)
      report=report.where(:type=>["IncidentReport","MaintenanceReport"]).order(:approach_time)
      report_map[round] = report
      note_map[round] = note
      round_time_start=round_time_end
    end
    
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def end_shift    
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
  
  def update_todo
    task_list = params[:task]
    TaskAssignment.where(:shift_id => current_staff.current_shift.id).each do | assignment |
	logger.debug("Assignment #{task_list[assignment.task_id]}")
      assignment.done = task_list[assignment.task_id.to_s] != nil
	  assignment.save
    end
  
	respond_to do |format|
	  format.iphone { render :nothing => true }
	end
  end
  
  private
  def report_map
    @report_map ||= Hash.new
  end
  
  def note_map
    @note_map ||= Hash.new
  end
  
end
