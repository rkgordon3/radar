class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authorize
	unless staff_signed_in?
		flash[:notice] = "Unauthorized Access"
		redirect_to "/home/landingpage"
		false
	end
  end
  
end
