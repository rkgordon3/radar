class TutorReportsController < ReportsController

  before_filter :authenticate_staff!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource
  

  def create
    @report = session[:report] 
    super  
  end
  

  def update
    @report = session[:report]  
    super
  end
  

  def new
    @report =  param_value_present(params[:type]) ? 
	                        params[:type].constantize.new(:staff_id => current_staff.id)
	                      : TutorReport.new(:staff_id => current_staff.id) 
    super
  end

  def index
    @report = @tutor_report
    super
  end

  def show
    @tutor_report = Report.find(params[:id])
    @report = @tutor_report
    super
  end

  def edit
    @report = @tutor_report
    super
  end

  def destroy
    @report = @tutor_report
    super
  end
end
