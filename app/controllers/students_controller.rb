class StudentsController < ApplicationController
  before_filter :authenticate_staff!
  load_and_authorize_resource
  
  # GET /students
  # GET /students.xml
  def index
    # @students loaded by CanCan
    @students = @students.where(:is_active => true).paginate(:page => params[:page], :per_page => INDEX_PAGE_SIZE)
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
  



end
