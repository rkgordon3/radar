class Report < ActiveRecord::Base
  belongs_to  	:staff
  belongs_to    :building
  has_many      :interested_party_reports
  has_one		    :annotation
  has_many      :report_participant_relationships
  belongs_to    :annotation
  after_initialize :setup_defaults
  after_save       :save_everything
  before_destroy   :destroy_everything
  
  # return true if report is a generic report, ie FYI
  def is_generic? 
    type == nil
  end

  def times_forwarded_to(interested_party)
    ip = InterestedPartyReport.find_by_interested_party_id_and_report_id(interested_party.id, self.id)
    if ip == nil
      return 0
    end
    return ip.times_forwarded
  end

  def submitter?(staff)
    staff||=Staff.new
    return staff.id==self.staff.id
  end
  
  def is_note?
    type == "Note"
  end
  
  def created_at_string
    self.created_at.to_s(:my_time)
  end

  def created_at_string
    self.created_at.to_s(:my_time)
  end

  def updated_at_string
    self.updated_at.to_s(:my_time)
  end

  def can_submit_from_mobile?
    false
  end
  
  def type_id
    ReportType.find_by_name(self.type).id
  end
  
  def can_edit_from_mobile?
    false
  end
  
  def annotation_text
    annotation != nil ? annotation.text : nil
  end
  
  def update_attributes_and_save(params)
    update_attributes_without_saving(params)
    valid?
    save
  end
  
  def supports_selectable_contact_reasons?
    false
  end
  
  def reasons(student = nil)
    RelationshipToReport.for(self)
  end
  
  def update_attributes_without_saving(params)
    self.building_id = params[:building_id]
    self.room_number = params[:room_number]
    self.approach_time = params[:approach_time] || Time.now
    self.approach_time = Time.zone.local_to_utc(approach_time)
    self.submitted = (params[:submitted] != nil) 
    annotation_text = params[:annotation]
    
    if annotation_text != nil && annotation_text.length > 0 
      if self.annotation == nil
        self.annotation = Annotation.new(:text => annotation_text)
      else
        self.annotation.text = annotation_text
      end
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
    if annotation != nil && annotation.save != nil 
      self.annotation_id = annotation.id
    end
    super
  end
  
  def save_everything
    # save each reported infraction to database  
    self.report_participant_relationships.each do |ri|
      if !ri.frozen?   # make sure the reported infraction isn't frozen
        ri.report_id = self.id # establish connection
        ri.save		# actually save
      end
    end
    if (self.submitted) 
      Notification.immediate_notify(self.id)
    end
  end
  
  def destroy_everything
    destroy_participants
    if annotation != nil
      annotation.destroy
    end
  end
  
  def contact_reasons_for(participant_id)
    self.report_participant_relationships.select { |ri| ri.participant_id == participant_id } 
  end
 
  def destroy_participants
    report_participant_relationships.each do |ri|
      ri.destroy
    end
  end
  
  def get_contact_reason_for_participant(participant_id, reason_id)
    self.report_participant_relationships.select { |ri|
      ri.participant_id == participant_id && ri.relationship_to_report_id == reason_id }.first
  end
  
  #return true if participant is associated with report
  def associated?(participant) 
    participant != nil && participant_ids.include?(participant.id)
  end
  
  def empty_of_participants?
    participant_ids.size == 0
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
  
  def add_default_contact_reason(participant_id)
    # only want to add if fyi doesn't already exist
    all_relationships_for_participant = contact_reasons_for(participant_id)
    
    # only want to add if no relationships exist
    if all_relationships_for_participant.count == 0
      ri = ReportParticipantRelationship.new(:participant_id => participant_id)
      if self.is_a? MaintenanceReport
        ri.relationship_to_report_id = RelationshipToReport.maintenance_concern
      end
      self.report_participant_relationships << ri
    else
      ri = get_contact_reason_for_participant(participant_id, RelationshipToReport.fyi) 
    end
    return ri
  end
   
  def add_contact_reason_for(participant_id, reason_id)
    ri = get_contact_reason_for_participant(participant_id, reason_id) 
    
    if ri == nil
      ri = ReportParticipantRelationship.new(:participant_id => participant_id, :relationship_to_report_id => reason_id)
      self.report_participant_relationships << ri
    end
    
    return ri
  end
  
  def remove_contact_reason_for(participant_id, reason_id)
    self.report_participant_relationships.delete(get_relationship(participant_id, reason_id)) rescue nil
  end
  
  def get_relationship(participant_id, reason_id)
    report_participant_relationships.select { |r| r.participant_id == participant_id && r.relationship_to_report_id == reason_id }
  end
  
  def tag	
    tag = ReportType.find_by_name(self.class.name).abbreviation + "-" + tag_datetime + "-" + staff_id.to_s
  end
  
  def event_time
    (approach_time != nil ? approach_time : created_at).to_s(:time_only)
  end
 
  def event_date
 	  (approach_time != nil ? approach_time : created_at).strftime("%m/%d/%Y")
  end
 
  def Report.sort(data,key)
    new_data = data.order("approach_time DESC")
    if key=="time"
      #default already sorted by time
    elsif key=="area"
      new_data = data.joins(:building=>:area).order("areas.name ASC")
    elsif key=="type"
      new_data = data.order("type ASC")
    elsif key=="building"
      new_data = data.joins(:building).order("name ASC")
    elsif key=="location"
      new_data = data.order("room_number ASC")
    elsif key=="tag"
      new_data = data.order("tag DESC")
    elsif key=="submitter"
      new_data = data.joins(:staff).order("last_name " + "ASC")
    end
    return new_data
  end
 
  def display_name
    return ReportType.find_by_name(self.class.name).display_name
  end
  # An array of participant IDs
  def add_participants(participants)
    participants.each do |id|
      self.add_default_contact_reason(id)
    end
  end
  
  private
  def tag_datetime
    (approach_time != nil ? approach_time : created_at).strftime("%Y%m%d-%H%M")
  end
end