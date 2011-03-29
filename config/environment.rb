# Load the rails application
require File.expand_path('../application', __FILE__)

STUDENT_THUMBS_PATH = "http://140.190.65.61:1337/gallery3/var/thumbs/edu.smumn."

STUDENT_IMAGES_PATH = "http://140.190.65.61:1337/gallery3/var/resizes/"

# Initialize the rails application
Radar::Application.initialize!

