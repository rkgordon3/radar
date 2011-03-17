class Student < Participant
	belongs_to :building
	
	#self.view_name = "participant_view" 
	
	def full_name
		"#{self.first_name} #{self.last_name}, #{self.building.abbreviation}, #{self.room_number}"
		end
	def get_id
		"#{:id}"
	end
	
	def Student.get_id_from_name_building_room(f_name, building_id, room_number)
		return Student.where("full_name LIKE ? AND building_id <= ? AND room_number <= ?",
			f_name, building_id, room_number)
	end
	
	# gets the student for a string formatted "full name, building, room number"
	def Student.get_student_object_for_string(name_string)
  	  message= name_string
  	  split_up = message.split(/, /)
	
  	  long_name = split_up[0]
  	  #print long_name
  	  building_id = split_up[1]
  	  #print s_building_id
  	  room_number = split_up[2]
  	  #print s_room_number
	
  	  student_id = Student.get_id_from_name_building_room(
		long_name,building_id,room_number)
	
	  student = Student.find(student_id)
	
	  return student
  	  
  	end
	
	
	
end
