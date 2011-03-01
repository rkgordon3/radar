class HomeController < ApplicationController
	
  def landingpage
  @reports = Report.all
  
  @recent = Report.where("created_at > ?", current_staff.last_sign_in_at)
  end

end
