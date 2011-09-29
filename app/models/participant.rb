class Participant < ActiveRecord::Base
  belongs_to :building

  def contact_history
   rp = ReportParticipantRelationship.where("participant_id = ?", self.id).order(:created_at)
   rp.collect { |rp| 
     c = ParticipantsHelper::ContactSummary.new
	 c.report = rp.report rescue unknown
	 c.date = rp.report.approach_time.to_s(:my_time) rescue unknown
	 c.reason = rp.relationship_to_report.description rescue unknown
     c
   }
  end
  
  def name
    first_name + " " + (middle_initial != nil ? (middle_initial + " ") : "") + last_name
  end
  
  def getImageUrl
    url_for_id = UrlForId.find(self.student_id) rescue nil 
	if ( url_for_id.nil? ||   url_for_id.url.nil?) 
     	return ApplicationHelper::unknown_image
	end
    IMAGE_PATH + url_for_id.url 
  end
		
	def Participant.get_participant_for_full_name(name_string)
    message= name_string
    split_up = message.split(/, /)
	
	# The gsub is a kludge to fix extra space in long name for those 
	# names without middle initial
    long_name = split_up[0].gsub("  ", " ")
    #print long_name
    building_abbreviation = split_up[1]
    #print s_building_id
    room_number = split_up[2]
    #print s_room_number


    participant = Participant.get_participant_from_name_building_room(long_name,building_abbreviation,room_number)
	  if participant == nil
	    return nil
	  else
	    if participant.first == nil
        participant = Participant.where("full_name LIKE ?", long_name)
        return participant.first
      end
	    return participant.first
    end
  end
	
	# rkg why are inequalities used?
	# Why get_id? You are getting student(s)?
	def Participant.get_participant_from_name_building_room(f_name, building_abbreviation, room_number)
		return Participant.joins(:building).where("full_name LIKE ? AND buildings.abbreviation = ? AND room_number = ?",
			f_name, building_abbreviation, room_number)
		
		# rkg why not
		# s = Student.where (...)
		# return s.id
		
		# but both approaches assume only one match. Is this safe assumption?
	end
	
	def age
	dob = self.birthday
    unless dob.nil?
      a = Date.today.year - dob.year
      b = Date.new(Date.today.year, dob.month, dob.day)
      a = a-1 if b > Date.today
      return a.to_s
    end
    unknown
  end

  def birthday_string
    self.birthday.to_s(:short_date_only) rescue unknown
  end
  
  def is_of_drinking_age? 
     !self.birthday.nil? && self.birthday < (-drinking_age).years.from_now 
  end

end
