# Load the rails application
require File.expand_path('../application', __FILE__)
require 'socket'

DEFAULT_IMAGE_PATH = "http://140.190.65.61:1337/gallery3/var/resizes/edu.smumn."

VENDOR_IMAGE_PATH = nil

IMAGE_PATH = VENDOR_IMAGE_PATH || DEFAULT_IMAGE_PATH
	
def report_host_ip
 Socket.getaddrinfo(Socket.gethostname,nil).select{|t| t[0] == 'AF_INET'}[0][3]
end

# Initialize the rails application
Radar::Application.initialize!
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp 
ActionMailer::Base.smtp_settings = {
:address => "mail.smumn.edu",
:port => 25}

