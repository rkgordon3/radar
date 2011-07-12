class ApplicationController < ActionController::Base
	before_filter :set_iphone_format
	protect_from_forgery
	
	def general_authorize
		unless staff_signed_in?
			flash[:notice] = "Unauthorized Access"
			redirect_to "/staffs/sign_in"
			false
		end
	end
	def set_iphone_format
		if is_iphone_request? || is_android_request?
			request.format = :iphone
		end
	end

	def is_iphone_request?
		#true
    request.user_agent =~ /(Mobile\/.+Safari)/
	end  
	
	def is_android_request?
		request.user_agent =~ /(Android)/
	end

  private
  
  def current_ability
    @current_ability ||= Ability.new(current_staff)
  end
  
end