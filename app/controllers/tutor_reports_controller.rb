class TutorReportsController < ReportsController

  before_filter :authenticate_staff!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource
  

  def new
    @report =  param_value_present(params[:type]) ? 
	                        params[:type].constantize.new(:staff_id => current_staff.id)
	                      : TutorReport.new(:staff_id => current_staff.id) 
    super
  end


end
