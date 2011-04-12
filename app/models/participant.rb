class Participant < ActiveRecord::Base
  	def getImageUrl
  					
  					email == nil ? "" : STUDENT_IMAGES_PATH + email.downcase
  	 end
  	 
  	 def getThumbnailUrl
  	 				 email == nil ? "" : STUDENT_THUMBS_PATH + email.downcase
  	 end
	
end
