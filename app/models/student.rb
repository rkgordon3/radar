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



	
	# gets the student for a string formatted "full name, building, room number"
	# rkg I think arg is poorly named, no? It is not name, it is some sort of aggregate
	# of name, bldg, room# is it not? 	
	
	def getAge(dob)
     unless dob.nil?
       a = Date.today.year - dob.year
       b = Date.new(Date.today.year, dob.month, dob.day)
       a = a-1 if b > Date.today
       return a
     end
     nil
   end	
  	 

	
	
	
end
