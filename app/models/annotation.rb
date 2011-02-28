class Annotation < ActiveRecord::Base
	
	
	def update_text(t)
		self.text = t
		self.save
	end
	
	
	
	
end
