class ShiftsController < ApplicationController
  
  
  
  # GET /shifts
  # GET /shifts.xml
  helper_method :round_map
  before_filter :authenticate_staff!
  before_filter :ra_authorize_view_access
  skip_before_filter :verify_authenticity_token
  
  
  def index
    
    reorder
    
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
    @shift.save
    
    respond_to do |format|
      format.js
      format.iphone {
        render :update do |page|
          # page.insert_html(:top, "inside_container", "<div id = \"flash_notice\"> You are now on duty. </div>")
          page.replace_html("duty_button", :partial=>"shifts/end_shift_button" )
          page.replace_html("round_button", :partial=>"rounds/start_round_button" )
        end
      }
    end
  end
  
  def duty_log
    
    @shift=Shift.find(params[:id])
    @rounds=Round.where("shift_id = ?",params[:id]).order(:end_time)
    round_time_start=@shift.created_at
    @rounds.each do |round|
      round_time_end=round.end_time
      rep=Report.where(:staff_id=>@shift.staff_id, :approach_time => round_time_start..round_time_end)
      round_map[round] =rep
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
      notice = "You are now off a round and off duty."
    else
      notice = "You are now off duty."		
    end
    
    respond_to do |format|
      format.js
      format.iphone {
        render :update do |page|	
          #page.insert_html(:top, "inside_container", "<div id = \"flash_notice\"> #{notice} </div>")
          page.replace_html("duty_button", :partial=>"shifts/start_shift_button")
          page.replace_html("round_button", "" )
        end
      }
    end
  end
  
  def reorder
    @shifts = Shift.order("created_at DESC")
    if params[:sort]=="date"
      #default already sorted by date
    elsif params[:sort]=="area"
      @shifts=Shift.joins(:area).order("name ASC")
    elsif params[:sort]=="submitter"
      @shifts=Shift.joins(:staff).order("last_name " + "ASC")
    end
  end
  
  private
  def round_map
    @round_map ||= Hash.new
  end
  
end
