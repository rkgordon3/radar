class Student < Participant
	
	def full_name
		"#{self.first_name} #{self.middle_initial} #{self.last_name}, #{self.building.abbreviation}, #{self.room_number}"
    end
 
	
	def residence_hall
	  building.name rescue unspecified
	end
	
	 def grade_level
      (not classification.nil?) ? classification : unknown
	end
  
end
