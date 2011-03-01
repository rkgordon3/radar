class HomeController < ApplicationController
	
  def landingpage
  @reports = Report.all
  if staff_signed_in?
	@unsubmitted = Report.where("submitted = ? AND staff_id = ?", false, current_staff.id)
  end
  end

end
