class Participant < ActiveRecord::Base
  	def getImageUrl 		 
  					STUDENT_IMAGES_PATH + (email.downcase rescue "unknown")
  	 end
  	 
  	 def getThumbnailUrl
  	 				 STUDENT_THUMBS_PATH + (email.downcase rescue "unknown")
  	 end
	
end
