class TutorReportsController < ReportsController

  before_filter :authenticate_staff!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource
  

  def create
    @report = session[:report]
    # process parameters into reported infractions
    @report.add_contact_reason(params)   
    super  
  end
  

  def update
    @report = session[:report]
    # process check boxes to update reported infractions
    @report.add_contact_reason(params)   
    super
  end
  

  def new
  logger.debug("****************In TutorController NEW  ")
    @report =  param_value_present(params[:type]) ? 
	                        params[:type].constantize.new(:staff_id => current_staff.id)
	                      : TutorReport.new(:staff_id => current_staff.id) 

logger.debug("****************TutorController NEW  #{@report.class.name}")

						  # new report
    super
  end

  def index
    @report = @tutor_report
    super
  end

  def show
    logger.debug "!!!!!!!!!!!"
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
