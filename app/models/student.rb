class Student < Participant
	belongs_to :building
	
<<<<<<< HEAD
	def full_name
		"#{self.first_name} #{self.last_name} #{self.building.abbreviation} #{self.room_number}"
=======
	def get_id
		"#{:id}"
>>>>>>> cf3dc711e0dd3ac7a8650072665dae68ea0afe1c
	end
end
