class HomeController < ApplicationController
	

  
  def landingpage
    @reports = Report.all
    if staff_signed_in?
      @unsubmitted = IncidentReport.where("submitted = ? AND staff_id = ?", false, current_staff.id)
      @recent = IncidentReport.where("Reports.created_at > ? AND submitted = ?", current_staff.last_sign_in_at, true)
      @unsubmitted = Report.sort(@unsubmitted,params[:sort])
      @recent = Report.sort(@recent,params[:sort])
    end
  
   respond_to do |format|
      format.html
      format.xml
      format.iphone {render :layout => 'mobile_application'}
      format.js
    end
  end
  
end