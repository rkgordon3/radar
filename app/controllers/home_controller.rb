class HomeController < ApplicationController
	
  def landingpage
    @reports = Report.all
    if staff_signed_in?
	     @unsubmitted = IncidentReport.where("submitted = ? AND staff_id = ?", false, current_staff.id)
	     @recent = IncidentReport.where("created_at > ? AND submitted = ?", current_staff.last_sign_in_at, true)
    end
  end
  
  
end
