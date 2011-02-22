class Student < Participant
	belongs_to :building
	
	def full_name
		"#{self.first_name} #{self.last_name} #{self.building.abbreviation} #{self.room_number}"
	end
end
