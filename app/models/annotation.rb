class Annotation < ActiveRecord::Base
	belongs_to :report
	
	def get_id
		"#{:id}"
	end
end
