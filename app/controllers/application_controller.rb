class ApplicationController < ActionController::Base
	before_filter :set_iphone_format
	protect_from_forgery

	def general_authorize
		unless staff_signed_in?
			flash[:notice] = "Unauthorized Access"
			redirect_to "/home/landingpage"
			false
		end
	end
	def set_iphone_format
		if is_iphone_request?
			request.format = :iphone
		end
	end

	def is_iphone_request?
		#TRUE
		request.user_agent =~ /(Mobile\/.+Safari)/
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