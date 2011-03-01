class HomeController < ApplicationController
	
  def landingpage
  @reports = Report.all
  if staff_signed_in?
	@unsubmitted = Report.where("submitted = ? AND staff_id = ?", false, current_staff.id)
    @recent = Report.where("created_at > ?", current_staff.last_sign_in_at)
  end
  end
end
