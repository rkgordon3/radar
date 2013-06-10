class Participant < ActiveRecord::Base
  belongs_to :building
  has_many :report_participant_relationships
  has_many :reports, :through => :report_participant_relationships
  # Used with seach results so that only active participants are 'found'
  # Not used with autocomplete
  scope :active, lambda { where(:is_active => true) }

  #returns all relationships accessible by the given ability and of the same type
  #as the report given, excluding those associated with that report specifically.
  def contact_history(ability, report=nil)
	# FIXME
    # The first condition within the select block is a work-around for report_participant_relationships
	# which are NOT associated with a report. This indicates some latent but which has not been yet
	# understood. The test for not nil avoid an error when display the participants who appear in these
	# bad report_participant_relationships
	rp = (not report.nil?) ? report_participant_relationships.accessible_by(ability).select { |r| (not r.report.nil?) && (r.report.type == report.type) && (r.report != report) }
			           : report_participant_relationships.accessible_by(ability)
	
	#rp.sort { |r0, r1| r0.report.approach_time <=> r1.report.approach_time } 
    contacts = {}
    rp.each { |rp|
	  if (contacts[rp.report_id].nil?)
        c = ParticipantsHelper::ContactSummary.new
		contacts[rp.report_id] = c
		c.reasons = []
        c.report = rp.report rescue unknown
        #c.date = rp.report.approach_time.to_s(:short_date_only) rescue unknown
		c.date = rp.report.approach_time rescue unknown
	  end
      contacts[rp.report_id].reasons << rp.reason.description rescue unknown
    }
	contacts.values.sort { |c0, c1| c0.date <=> c1.date }
  end
  
  def name
    ((first_name.nil? ? "" : first_name) + " " + (middle_initial.nil? ?  "" : (middle_initial + " ")) + (last_name.nil? ? "" : last_name)).strip()
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
		# from http://stackoverflow.com/questions/819263/get-persons-age-in-ruby
		unless self.birthday?
		  return (Time.now.to_s(:number).to_i - birthday.to_time.to_s(:number).to_i)/10e9.to_i
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
