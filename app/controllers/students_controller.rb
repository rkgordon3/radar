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
  def search_results
    @students = nil
    student = nil
    
    # if a student's name was entered, find all reports with that student
    if params[:student_id]!= "" # arbitrary number
      # get the student by his/her ID
      search_string = "\"student_id\" LIKE \"" + params[:student_id] + "%\""
      student = Student.where(search_string)
      
      @students = student
    end
    
    # if a student's name was entered, find all reports with that student
    if params[:full_name].length != "" # arbitrary number
      # get the student for the string entered
      student = Student.get_student_object_for_string(params[:full_name])
      if student != nil
        @students = Array.new << student
      else 
        @students = Student.where("full_name LIKE ?", "%#{params[:full_name]}%")
      end
    end
    
    
    #----------------
    # if no student was selected, select all 
    if @students == nil
      @students = Student.where(:type => "Student")
      
      
      
      #-----------------
      # if a building was selected, get students in that building
      if params[:building_id] != Building.unspecified.to_s
        @students = @students.where(:building_id => params[:building_id])
        
        #-----------------
        # if a building was selected, get students in that building
        if params[:room_number] != Building.unspecified.to_s
          @students = @students.where(:room_number => params[:room_number])
        end
      end
      
      
      #-----------------
      # if an area was selected, get students in that area
      if params[:area_id] != Area.unspecified.to_s && params[:building_id] == Building.unspecified.to_s
        buildings = Building.where(:area_id => params[:area_id])
        @students = @students.where(:building_id => buildings)
        
      end
      
      #-----------------
      # if a date was provided, find all before that date
      if params[:student][:"before_birthdate(1i)"] != "" 
        # be careful of time zones - all need to be in GMT to match the DB
        date = "#{params[:student][:"before_birthdate(1i)"].to_i}/#{params[:student][:"before_birthdate(2i)"].to_i}/#{params[:student][:"before_birthdate(3i)"].to_i}"
        min = Time.parse("01/01/1970").gmtime
        max = Time.parse(date).gmtime
        
        @students = @students.where(:birthday => min..max )
      end
      
      #-----------------
      # if a date was provided, find all after that date
      if params[:student][:"after_birthdate(1i)"] != "" 
        # be careful of time zones - all need to be in GMT to match the DB
        date = "#{params[:student][:"after_birthdate(1i)"].to_i}/#{params[:student][:"after_birthdate(2i)"].to_i}/#{params[:student][:"after_birthdate(3i)"].to_i}"
        min = Time.parse(date).gmtime
        max = Time.now.gmtime
        
        @students = @students.where(:birthday => min..max )
      end
      
      
      
      @students = @students.order(:last_name)
    end
    
    @num_results = @students.count
    
    respond_to do |format|
      format.html
    end
  end
  
  
  def use_search_results_to_create_new_report
    @incident_report = IncidentReport.new
    
    keys = params.keys
    
    for key in keys
      participant = Participant.where(:id => key)
      
      if participant.first != nil
        @incident_report.add_default_relationship_to_report_for_participant(participant.first.id)  
      end
    end
    
    session[:incident_report] = @incident_report
   
    respond_to do |format|
      format.html { redirect_to "/incident_reports/new_report" }
      format.xml  { render :xml => @incident_report}
    end
  
  end
  
  
  
end
