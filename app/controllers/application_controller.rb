class ApplicationController < ActionController::Base
	before_filter :set_iphone_format
	protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to("/", :notice => "Unauthorized Access")
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

  def current_ability
    @current_ability ||= Ability.new(current_staff)
  end
  
  def param_value_present(param)
    (not param.nil?) && (not param.empty?)
  end
  
end