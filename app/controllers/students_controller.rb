class StudentsController < ApplicationController
  before_filter :authenticate_staff!
  load_and_authorize_resource
  
  # GET /students
  # GET /students.xml
  def index
    # @students loaded by CanCan
    @students = @students.where(:is_active => true).paginate(:page => params[:page], :per_page => 30)
    if params[:sort] == nil
      @students = @students.order(:last_name)
    elsif params[:sort]=="building"
      @students = @students.joins(:building).order("name ASC")
    else
      @students = @students.order(params[:sort])
    end
    
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
  
  
  def show_details
    respond_to do |format|
      format.js
    end
  end
  
  # POST 
  def search_results
  	@students = nil
    student = nil
    
    # if a student's name was entered
    if param_value_present(params[:student_id])
      # get the student by his/her ID
      #search_string = "\"student_id\" LIKE " + params[:student_id] + "%"
      student = Student.where("student_id LIKE ?", "%#{params[:student_id]}%")
      
      @students = student
    end
    
    # if a student's name was entered, find all reports with that student
    if param_value_present(params[:full_name]) # arbitrary number
      # get the student for the string entered
      student = Participant.get_participant_for_full_name(params[:full_name])
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
      if param_value_present(params[:building_id]) && (params[:building_id] != Building.unspecified_id.to_s)
        @students = @students.where(:building_id => params[:building_id])
        
        #-----------------
        # if a building was selected, get students in that building
       
        if param_value_present(params[:room_number])
          @students = @students.where(:room_number => params[:room_number])
        end
      end
      
      #logger.debug("****************Area = #{params[:area_id]} Building = #{params[:building_id]}")
      
      #-----------------
      # if an area was selected, get students in that area
      if params[:area_id] != Area.unspecified_id.to_s && params[:building_id] == Building.unspecified_id.to_s
        buildings = Building.where(:area_id => params[:area_id])
        @students = @students.where(:building_id => buildings)
        
      end
      if param_value_present(params[:student])
		  #-----------------
		  # if a date was provided, find all before that date
		  born_before = params[:student][:born_before]
	      max,min = Time.now.gmtime, Time.parse("01/01/1970").gmtime
		  filter_by_date = false
		  
		  if param_value_present(born_before)  	
			max = convert_arg_date(born_before) rescue nil
			filter_by_date = true if !max.nil?
		  end

		  
		  #-----------------
		  # if a date was provided, find all after that date
		  born_after = params[:student][:born_after]

		  if  param_value_present(born_after)  
			dd,mm,yy = $1, $2, $3 if born_after =~ /(\d{2})-([A-Z|a-z]{3})-(\d{4})/
			min = convert_arg_date(born_after) rescue nil
			filter_by_date = true if !min.nil?
		  end 
		  logger.debug("max = #{max} min = #{min} filter = #{filter_by_date}")
		  @students = @students.where(:birthday => min..max ) if filter_by_date
	  end
      @students = @students.order(:last_name)
    end
    
    @num_results = @students.count
    
    respond_to do |format|
      format.html
	  format.iphone  { render  :layout => 'mobile_application' }
    end
  end
  
  
  def use_search_results_to_create_new_report
    if params[:commit] == "Add To New Maintenance Request"
      report_folder = "maintenance_reports/new"
    else
      report_folder = "incident_reports/new"
    end
	qstring = ""
	params[:participants].keys.each do |k|
		qstring << "participants[]=#{k}&"
	end
         
    respond_to do |format|
      format.html { redirect_to "/#{report_folder}?#{qstring}"  }
	  format.iphone { redirect_to "/#{report_folder}?#{qstring}" }
    end
  
  end
  
  private
	def convert_arg_date(date)
		dd,mm,yy = $1, $2, $3 if date =~ /(\d+)-([A-Z|a-z]{3})-(\d{4})/
		logger.debug("yy = #{yy} mm = #{mm} dd = #{dd}")
		Time.mktime(yy, mm, dd).gmtime
	end	

end
