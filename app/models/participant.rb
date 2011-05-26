class Participant < ActiveRecord::Base
  	def getImageUrl
        url_for_id = UrlForId.find(self.student_id) rescue nil
        IMAGE_PATH + (url_for_id != nil ? url_for_id.url : (self.email.downcase rescue "unknown"))
  	 end
		
	def Participant.get_participant_for_full_name(name_string)
	  logger.debug "IN GET PARTICIPANT"
  	  message= name_string
  	  split_up = message.split(/, /)
	
  	  long_name = split_up[0]
  	  #print long_name
  	  building_id = split_up[1]
  	  #print s_building_id
  	  room_number = split_up[2]
  	  #print s_room_number
	
  	  # rkg why query database twice to get id?

  	  participant = Participant.get_participant_from_name_building_room(long_name,building_id,room_number)
	  if participant == nil
	    return nil
	  else
	    if participant.first == nil
		  participant = Participant.where("full_name LIKE ?", long_name)
		  logger.debug "PARTICIPANT FULL NAME ONLY = #{participant.first}"
		  return participant.first
		end
	    return participant.first
  	  end
  	end
	
	# rkg why are inequalities used?
	# Why get_id? You are getting student(s)?
	def Participant.get_participant_from_name_building_room(f_name, building_id, room_number)
		return Participant.where("full_name LIKE ? AND building_id <= ? AND room_number <= ?",
			f_name, building_id, room_number)
		
		# rkg why not
		# s = Student.where (...)
		# return s.id
		
		# but both approaches assume only one match. Is this safe assumption?
	end
	
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
