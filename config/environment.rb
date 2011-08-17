# Load the rails application
require File.expand_path('../application', __FILE__)
require 'socket'


#useful global

	def unspecified 
	  "Unspecified"
	end
	


# Gallery image path when Radar hosts images, as opposed to client
DEFAULT_IMAGE_PATH = "http://140.190.65.61:1337/gallery3/var/resizes/edu.smumn."

# When pulling images from webtools, uncomment this line. More generally,
# when pulling from a vendor-specified image repository, uncomment this line
# and set to URL of repository. This value is used in conjunction with
# URL_FOR_ID table, which maps ID to participant specific piece of URL.
# The student specific piece is appended to CLIENT_IMAGE_PATH to determine
# location of student image.
CLIENT_IMAGE_PATH = "https://webtools.smumn.edu/images/"
#CLIENT_IMAGE_PATH = nil

IMAGE_PATH = CLIENT_IMAGE_PATH || DEFAULT_IMAGE_PATH
	
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

