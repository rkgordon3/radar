class HomeController < ApplicationController
	
  def landingpage
  @reports = Report.all
  if staff_signed_in?
	@unsubmitted = Report.where("submitted = ? AND staff_id = ?", false, current_staff.id)
	@recent = Report.where("created_at > ? AND submitted = ?", current_staff.last_sign_in_at, true)
  end
   respond_to do |format|
      format.html # index.html.erb
      format.iphone {render :layout => 'mobile_application'}
    end
  end
end
