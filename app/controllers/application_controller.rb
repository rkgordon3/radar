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
		#TRUE
		request.user_agent =~ /(Mobile\/.+Safari)/	
	end  
	
	def is_android_request?
		request.user_agent =~ /(Android)/
	end
	
  def ra_authorize_view_access
    if staff_signed_in?
      unless Authorize.ra_authorize(current_staff)
        flash[:notice] = "Unauthorized Access"
        redirect_to "/home/landingpage"
        false
      end
    end 
  end 
  
  def admin_assistant_authorize_view_access
    if staff_signed_in?
      unless Authorize.admin_assistant_authorize(current_staff)
        flash[:notice] = "Unauthorized Access"
        redirect_to "/home/landingpage"
        false
      end
    end 
  end 
  
   def not_admin_assistant_authorize_view_access
    if staff_signed_in?
      unless Authorize.not_admin_assistant_authorize(current_staff)
        flash[:notice] = "Unauthorized Access"
        redirect_to "/home/landingpage"
        false
      end
    end 
  end 
  
  def hd_authorize_view_access
    if staff_signed_in?
      unless Authorize.hd_authorize(current_staff)
        flash[:notice] = "Unauthorized Access"
        redirect_to "/home/landingpage"
        false
      end
    end 
  end 
  
  def admin_authorize_view_access
    if staff_signed_in?
      unless Authorize.admin_authorize(current_staff)
        flash[:notice] = "Unauthorized Access"
        redirect_to "/home/landingpage"
        false
      end
    end 
  end 
  
  def super_admin_authorize_view_access
    if staff_signed_in?
      unless Authorize.super_admin_authorize(current_staff)
        flash[:notice] = "Unauthorized Access"
        redirect_to "/home/landingpage"
        false
      end
    end 
  end 
  
end