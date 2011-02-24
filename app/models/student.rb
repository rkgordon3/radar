class Student < Participant
	belongs_to :building
	
	def get_id
		"#{:id}"
	end
end
