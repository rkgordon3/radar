class Student < Participant
	belongs_to :building
	
	#self.view_name = "participant_view" 
	
	def initialize(newId) 
		@id = newId
	end
	
	def full_name
		"#{self.first_name} #{self.last_name}, #{self.building.abbreviation}, #{self.room_number}"
		end
	def get_id
		"#{:id}"
	end
	# rkg why are inequalities used?
	# Why get_id? You are getting student(s)?
	def Student.get_id_from_name_building_room(f_name, building_id, room_number)
		return Student.where("full_name LIKE ? AND building_id <= ? AND room_number <= ?",
			f_name, building_id, room_number)
		
		# rkg why not
		# s = Student.where (...)
		# return s.id
		
		# but both approaches assume only one match. Is this safe assumption?
		
	end
	
	# gets the student for a string formatted "full name, building, room number"
	# rkg I think arg is poorly named, no? It is not name, it is some sort of aggregate
	# of name, bldg, room# is it not?
	
	def Student.get_student_object_for_string(name_string)
  	  message= name_string
  	  split_up = message.split(/, /)
	
  	  long_name = split_up[0]
  	  #print long_name
  	  building_id = split_up[1]
  	  #print s_building_id
  	  room_number = split_up[2]
  	  #print s_room_number
	
  	  # rkg why query database twice to get id?

  	  student_id = Student.get_id_from_name_building_room(
		long_name,building_id,room_number)
	
	  student = Student.find(student_id)
	
	  return student
  	  
  	end
	
	
	
end
