class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def general_authorize
	unless staff_signed_in?
		flash[:notice] = "Unauthorized Access"
		redirect_to "/home/landingpage"
		false
	end
  end
  
  def admin_authorize
	if staff_signed_in?
		unless current_staff.role == "Admin"
			flash[:notice] = "Unauthorized Access"
			redirect_to "/home/landingpage"
			false
		end
	else
		flash[:notice] = "Unauthorized Access"
		redirect_to "/home/landingpage"
		false
	end	
  end	
  
end
