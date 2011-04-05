class StudentsController < ApplicationController
  # GET /students
  # GET /students.xml
  before_filter :ra_authorize_view_access
  def index
    @students = Student.all
    @numRows = 0
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end
  
  # GET /students/1
  # GET /students/1.xml
  def show
    @student = Student.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end
  
  # GET /students/new
  # GET /students/new.xml
  def new
    @student = Student.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end
  
  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
  end
  
  # POST /students
  # POST /students.xml
  def create
    @student = Student.new(params[:student])
    
    respond_to do |format|
      if @student.save
        format.html { redirect_to(@student, :notice => 'Student was successfully created.') }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /students/1
  # PUT /students/1.xml
  def update
    @student = Student.find(params[:id])
    
    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to(@student, :notice => 'Student was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /students/1
  # DELETE /students/1.xml
  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    
    respond_to do |format|
      format.html { redirect_to(students_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def show_details
    logger.debug "IN SHOW DETAILS"
    @id = params[:id]
    @student = Student.find(@id)
    respond_to do |format|
      format.js
    end
  end
  
  # POST 
  def process_search_parameters
    @students = nil
    student = nil
    
    # if a student's name was entered, find all reports with that student
    if params[:student_id].length > 1 # arbitrary number
      # get the student by his/her ID
      search_string = "student_id LIKE " + params[:student_id] + "%"
      student = Student.where(search_string)
      
      @students = Array.new << student
    end
      
      # if a student's name was entered, find all reports with that student
    if params[:full_name].length > 3 # arbitrary number
      # get the student for the string entered
      student = Student.get_student_object_for_string(params[:full_name])
      
      @students = Array.new << student
    end
    
    
    
    
    #----------------
    # if no student or infraction was selected, select all 
    if @students == nil
      @students = Students.all
    end
    
    
    #    #-----------------
    #    # if a building was selected, get reports in that building
    #    if params[:building_id] != "0" 
    #      @reports = @reports.where(:building_id => params[:building_id])
    #    end
    #    
    #    #-----------------
    #    # if an area was selected, get reports in that area
    #    if params[:area_id] != "0" 
    #      buildings = Building.where(:area_id => params[:area_id])
    #      @reports = @reports.where(:building_id => buildings)
    #      
    #    end
    #    
    #    #-----------------
    #    # if a date was provided, find all before that date
    #    if params[:submitted_before] != "" 
    #      # all incident reports should take place in this century
    #      # be careful of time zones - all need to be in GMT to match the DB
    #      min = Time.parse("01/01/2000").gmtime
    #      max = Time.parse(params[:submitted_before]).gmtime
    #      
    #      @reports = @reports.where(:approach_time => min..max )
    #    end
    #    
    #    #-----------------
    #    # if a date was provided, find all after that date
    #    if params[:submitted_after] != "" 
    #      # all incident reports should take place before right now (ignoring daylight savings)
    #      # be careful of time zones - all need to be in GMT to match the DB
    #      min = Time.parse(params[:submitted_after]).gmtime
    #      max = Time.now.gmtime
    #      
    #      @reports = @reports.where(:approach_time => min..max )
    #    end
    #    
    #    
    #    # finishing touches...
    #    @reports = @reports.where(:submitted => true)    
    #    @reports = @reports.order(:approach_time)
    #    
    #    respond_to do |format|
    #      format.html # search.html.erb
    #    end
    #    
    respond_to do |format|
        format.html { redirect_to("/student/show_list", @students) }
        format.xml  { head :ok }
    end
        
  end

end
