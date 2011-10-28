# Load the rails application
require File.expand_path('../application', __FILE__)
require 'socket'



	

# this value identifies default affiliation of participants 
	CLIENT_AFFILIATION_TAG = "SMU"
	
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

#useful globals


	def unspecified 
	  "Unspecified"
	end
	
	def unknown 
	  "Unknown"
	end
	# set drinking age for your locale
	def drinking_age
	  21
	end
	
def report_host_ip
 "radar.smumn.edu"
end

def system_status_email
  "radar-admin@smumn.edu"
end

# Initialize the rails application
Radar::Application.initialize!
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp 
ActionMailer::Base.smtp_settings = {
:address => "mail.smumn.edu",
:port => 25}

