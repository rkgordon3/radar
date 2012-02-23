class Report < ActiveRecord::Base
  belongs_to  		:staff
  belongs_to    	:building
  belongs_to		:organization
  has_many      	:forwards, :foreign_key => :report_id, :class_name => "InterestedPartyReport"
  has_many     		:adjunct_submitters, :foreign_key => :report_id, :class_name => "ReportAdjunct"
  has_many		    :report_participant_relationships
  has_many			:participants, :through => :report_participant_relationships
  
  belongs_to    	:annotation
  after_initialize 	:setup_defaults
  after_find		:cache_submitted
  after_save       	:save_associations
  before_destroy   	:destroy_associations

  attr_accessible 	:type, :staff_id, :location
  
 
  scope :preferred_order, lambda { |user|  order("reports.#{user.preference(:sort_order)}") }
  scope :preferred, lambda { |user| where(:type=> user.preference(:report_type)) }
  
  scope :sort_by, lambda { |key|
    if key == "date"
      order("reports.approach_time DESC")
    elsif key == "time"
      order("reports.approach_time DESC")
    elsif key == "area"
      joins(:building=>:area).order("areas.name ASC")
    elsif key == "type"
      order("reports.type ASC")
    elsif key == "building"
      joins(:building).order("buildings.name ASC")
    elsif key == "location"
      order("reports.room_number ASC")
    elsif key == "tag"
      order("reports.tag DESC")
    elsif key == "submitter"
      joins(:staff).order("staffs.last_name ASC")
    else
      order("reports.#{user.preference(:sort_order)}")
    end
  }
  
  def default_contact_duration
	0
  end
  
  def location 
     ((self.room_number.nil?  ? "" : self.room_number) + " " + (self.building_name rescue unspecified)).strip
  end
  
  def default_contact_reason_id
	report_type.default_contact_reason_id
  end
    

  
  def is_generic?
    type == nil
  end

  def report_type
    @report_type ||= ReportType.find_by_name(self.type)
  end

  def times_forwarded_to(interested_party)
	ipforwards = forwards.select { |f| f.interested_party_id == interested_party.id }
	ipforwards.first.times_forwarded rescue 0
  end
  
  def forwarded?
	forwards.size > 0 
  end
  
  def forwardable?
    report_type.forwardable?
  end
  
  def supports_contact_reason_details?
    report_type.has_contact_reason_details?
  end
  
  def is_note?
    type == "Note"
  end
  

  def includes_secondary_submitter?(staff)
    ReportAdjunct.find_by_report_id_and_staff_id(self.id, staff.id) != nil
  end
  
  def is_adjunct?(ss)
    adjunct_submitters.each do |a|
     return true if a.staff_id == ss.id
    end
    false
  end

  def created_at_string
    self.created_at.to_s(:my_time)
  end

  def updated_at_string
    self.updated_at.to_s(:my_time)
  end

  def can_submit_from_mobile?
    report_type.submit_on_mobile?
  end
  
  def type_id
    report_type.id
  end
  
  def can_edit_from_mobile?
    report_type.edit_on_mobile?
  end
  
  # Return approach time format for Anytime.Pick
  # TODO : make a helper?
  # TODO : move to ReportType table?
  def approach_time_format
    "%b %e, %Y  %l:%M%p"
  end
  
  def approach_time_format_picker
	"%b %e, %Y  %l:%i%p"
  end
  
  def display_name
    return report_type.display_name
  end
  
  def annotation_text
    annotation != nil ? annotation.text : nil
  end
  
  def update_attributes_and_save(params)
    update_attributes_without_saving(params)
    valid?
    save!
  end
  
  def supports_selectable_contact_reasons?
    report_type.selectable_contact_reasons?
  end
  
  def reasons(student = nil)
    report_type.associated_reasons(student)
  end
  
  def common_reasons
    report_type.common_reasons(participant_ids)
  end
  
  def building_name
	self.building.name rescue unspecified
  end
  
  def update_attributes_without_saving(params)
    self.building_id = params[:building_id]
    self.building_id ||= Building.unspecified_id
    self.room_number = params[:room_number]
    self.approach_time = params[:approach_time] || Time.now
	logger.debug("++++++++++++++++++++ approach time #{self.approach_time}")
    self.approach_time = Time.zone.local_to_utc(approach_time)
    self.submitted = (params[:submitted] != nil) 

	self.organization_id = report_type.organization.id
	annotation_text = params[:annotation]
    if annotation_text != nil && annotation_text.length > 0   
        self.annotation = Annotation.new if self.annotation.nil?
        self.annotation.text = annotation_text
    end
	
	update_relationships(params)

    self.adjunct_submitters.each { |ra| ra.destroy }
    params[:report_adjuncts].each_pair { |key, value|  self.adjunct_submitters << ReportAdjunct.new(:staff_id => key) if value == "1" } if  not params[:report_adjuncts].nil?
  end
  
  def update_relationships(params)
	report_participant_relationships.destroy_all
	annotations = params[:annotations]
	durations = params[:durations]
	participants = params[:reason]
	participants.each_pair  do | pid, reasons |
		reasons.each_key do |reason_id| 
			rpr = ReportParticipantRelationship.new(:participant_id=>pid,  :relationship_to_report_id=>reason_id)
		    unless annotations.nil?
				rpr.annotation = Annotation.new(:text=>annotations[pid][reason_id]) if annotations[pid][reason_id].length > 0
			end
			unless durations.nil?
				rpr.contact_duration = ReportParticipantRelationship.parse_duration(durations[pid][reason_id] )
			end
			report_participant_relationships << rpr
		end		
		#add_default_contact_reason(pid) if report_participant_relationships.empty?
	end
	
  end
  
  
  def setup_defaults
    if self.id == nil
      self.building_id = Building.unspecified_id
      self.approach_time = Time.now
      self.submitted = false
      self.tag = tag
    end
  end
  
  def save
    if (not annotation.nil?) && annotation.save! != nil 
      self.annotation_id = annotation.id
    end
    super
  end

  def remove_default_contact_reason_if_redundant
	participants.each do |p|	 
		if contact_reasons_for(p.id).length > 1
	# We only remove default if annotation is nil
			cr = contact_reason_for_participant(p.id, default_contact_reason_id)
			unless cr.nil? || (not cr.annotation.nil?) 
			#||  ((not cr.contact_duration.nil?) and (cr.contact_duration > 0))
				remove_contact_reason_for(p.id,  default_contact_reason_id) 
			end
		end
	end	
  end
  
  def save_associations
	# save annotation
	self.annotation.save if not self.annotation.nil?
	remove_default_contact_reason_if_redundant 
    # save each reported infraction to database  
    self.report_participant_relationships.each do |ri|
      if !ri.frozen?   # make sure the reported infraction isn't frozen
        ri.context = report_type.reason_context unless ri.for_generic_reason?
		ri.contact_duration = default_contact_duration if ri.contact_duration.nil?
		ri.annotation.save if not ri.annotation.nil?
        ri.report_id = self.id # establish connection
        ri.save!		# actually save
      end
    end

    if generate_immediate_notification?
      Notification.immediate_notify(self.id)
    end
  end
  
  def destroy_associations
    report_participant_relationships.each { |ri| ri.destroy }
    adjunct_submitters.each { |ra| ra.destroy }

    unless annotation.nil? 
		annotation.destroy 
	end

  end
  
  def contact_reasons_for(participant_id)
    self.report_participant_relationships.select { |ri| ri.participant_id == participant_id } 
  end

  
  def contact_reason_for_participant(participant_id, reason_id)
	reason_id = reason_id.to_i if reason_id.is_a? String
	participant_id = participant_id.to_i if participant_id.is_a? String
	
    self.report_participant_relationships.select { |ri|
      ri.participant_id == participant_id && ri.relationship_to_report_id == reason_id }.first
  end
  
  #return true if participant is associated with report
  def associated?(participant) 
    (not participant.nil?) && participant_ids.include?(participant.id)
  end
  
  def empty_of_participants?
    participant_ids.size == 0
  end
  
  def number_of_participants
    participant_ids.size
  end
  
  # Return id of all participants associated with report
  def participant_ids
    partic_relationships = Array.new
    
    # populate the old reported infractions array with the report's infractions
    self.report_participant_relationships.each do |ri|
      partic_relationships << ri
    end
    
    # sort the infractions so all infractions by same student are grouped
    partic_relationships.sort! { |a, b|  a.participant.last_name <=> b.participant.last_name } 
    
    #create array for the participants we have
    participants = Array.new
    
    # if we have more than one old reported infraction
    if partic_relationships.count > 0
      # search for unique participants and save ids
      curr_participant_id = partic_relationships.first.participant_id
      participants << curr_participant_id
      
      partic_relationships.each do |ri|
        if curr_participant_id != ri.participant_id
          curr_participant_id = ri.participant_id
          participants << curr_participant_id
        end
      end # end loop
    end # end if more than one old reported infraction
    
    return participants
  end

   
  def add_contact_reason_for(participant_id, reason_id)
    unless contact_reason_for_participant(participant_id, reason_id)
      self.report_participant_relationships << ReportParticipantRelationship.new(:participant_id => participant_id, :relationship_to_report_id => reason_id)
	end
  end
  
  def add_default_contact_reason(participant_id)
  logger.info("=======> Add  default oparty=#{participant_id} for reason #{default_contact_reason_id}")
	add_contact_reason_for(participant_id, default_contact_reason_id)
  end
  
  def remove_participant(pid)
    p = pid.to_i if pid.is_a? String || pid
    contact_reasons_for(p).each do |ri|
      report_participant_relationships.delete(ri)
      ri.destroy
    end
  end
  
  def remove_contact_reason_for(participant_id, reason_id)
	reason = contact_reason_for_participant(participant_id, reason_id)
    self.report_participant_relationships.destroy(reason) if reason
  end
  
  def add_annotation_for(participant_id, reason, text)
    
    ri = contact_reason_for_participant(Integer(participant_id), Integer(reason))
	ActiveRecord::Base.logger.info("+++++++++++add_annotation_for report = #{self.id}  p=#{Integer(participant_id)} r= #{Integer(reason)} relation=#{ri.id} text= #{text}")
    unless ri.nil?
        if not ri.annotation.nil?
		ActiveRecord::Base.logger.info(" +++++ update existing annotation #{text}")
			ri.annotation.text = text
		else
		ActiveRecord::Base.logger.info(" +++++ create new annotation #{text}")
			ri.annotation = Annotation.new(:text=>text)
		end
    end
  end
  
  def remove_annotation_for(participant_id, reason)
    ri = contact_reason_for_participant(Integer(participant_id), Integer(reason))   
    ri.annotation = nil unless ri.nil?
  end
  
  def add_duration_for(participant_id, reason, minutes)
    ri = contact_reason_for_participant(Integer(participant_id), Integer(reason))
    if ri != nil
        ri.contact_duration = minutes
    end
  end

  def tag	
    tag = report_type.abbreviation + "-" + id.to_s
  end
  
  def event_time
    ( (not approach_time.nil?) ? approach_time : created_at).to_s(:time_only)
  end
 
  def event_date
	( (not approach_time.nil?) ? approach_time : created_at).to_s(:date_only)
  end

  def secondary_submitters_string
    s=""
    self.adjunct_submitters.joins(:staff).order(:last_name).each do |ra|
      s += "#{ra.staff.first_name} #{ra.staff.last_name}, "
    end
    s = s.chop
    s.chop
  end

  # An array of participant IDs
  def add_participants(participant_ids)
    participant_ids.each do |id|
      self.add_default_contact_reason(id)
    end
  end
  
   
  def update_durations(pids, reason, minutes)
	pids = self.participant_ids if pids.nil?
	pids.each do |pid|
      self.add_duration_for(pid, reason, minutes)
    end
  end
  
  def update_annotations(pids, reason, text)
	pids = self.participant_ids if pids.nil?

	pids.each do |pid|
      if text.nil? or (text.length == 0)
        self.remove_annotation_for(pid, reason)
      else
        self.add_annotation_for(pid, reason, text)
      end
    end
  end
 
  private  
  
  # after_find (load) we cache submitted value so we can
	# test here to see if immediate notification is warranted
	# if resource is new, @submitted_value_on_load
	# will not be defined.
  def generate_immediate_notification? 
	  submitted && ((not defined? @submitted_value_on_load) || (not @submitted_value_on_load) )
  end

  def cache_submitted
    @submitted_value_on_load = self.submitted
  end
  
  def tag_datetime
    (approach_time != nil ? approach_time : created_at).strftime("%Y%m%d-%H%M")
  end
  


end