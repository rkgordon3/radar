class Student < Participant
	
	def full_name
		"#{self.first_name} #{self.middle_initial} #{self.last_name}, #{residence_hall_abbreviation}, #{self.room_number}"
    end
 
	
	def residence_hall
	  building.name rescue unspecified
	end
	
	def residence_hall_abbreviation
	  self.building.abbreviation rescue 'UNK'
	end
	
	def grade_level
      (not classification.nil?) ? classification : unknown
	end
  
end
