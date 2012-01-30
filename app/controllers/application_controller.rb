class ApplicationController < ActionController::Base
	before_filter :set_iphone_format
	protect_from_forgery
	rescue_from CanCan::AccessDenied do |exception|
		logger.debug("##################### Acess denied action  #{exception.action} ")
		logger.debug("##################### Acess denied subject  #{exception.subject} ")
		logger.debug("##################### Acess denied #{exception.message} ")
		redirect_to("/", :notice => "Unauthorized Access: #{exception.message}" )
	end
  
	def set_iphone_format
		if is_iphone_request? || is_android_request?
			request.format = :iphone
		end
	end

	def is_iphone_request?
	  #true
      request.user_agent =~ /Mobile.+Safari/
	end  
	
	def is_android_request?
		request.user_agent =~ /(Android)/ 
	end

  def current_ability
    @current_ability ||= Ability.new(current_staff)
  end
  
  def param_value_present(param)
    return false if param == Array  && param.length == 0
    (not param.nil?) && (not param.empty?)
  end
  
  	def convert_arg_date(date)
		dd,mm,yy = $1, $2, $3 if date =~ /(\d+)-([A-Z|a-z]{3})-(\d{4})/
		Time.mktime(yy, mm, dd).gmtime
	end	
	
	def convert_arg_datetime(datetime)
	  dd,mm,yy, hh, min = $1, $2, $3, $4, $5 if datetime =~ /(\d+)-([A-Z|a-z]{3})-(\d{4}) (\d{2}):(\d{2})/
	  Time.mktime(yy, mm, dd, hh, min).gmtime
	end
  
end