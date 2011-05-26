# Load the rails application
require File.expand_path('../application', __FILE__)

DEFAULT_IMAGE_PATH = "http://140.190.65.61:1337/gallery3/var/resizes/edu.smumn."

VENDOR_IMAGE_PATH = "http://webtools.smumn.edu/images/"

IMAGE_PATH = VENDOR_IMAGE_PATH || DEFAULT_IMAGE_PATH

# Initialize the rails application
Radar::Application.initialize!
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp 
ActionMailer::Base.smtp_settings = {
:address => "mail.smumn.edu",
:port => 25}

