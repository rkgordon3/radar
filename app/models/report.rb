class Report < ActiveRecord::Base
  belongs_to  	:staff
  belongs_to    :building
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
  
  def is_note?
  	  type == "Note"
  end
  
  def can_submit_from_mobile?
    false
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
  
  
  def update_attributes_without_saving(params)
    logger.debug "IN REPORT.update attributes  params #{params}"
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
      self.building_id = Building.unspecified
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
  
  
  
  def get_report_participant_relationships_for_participant(participant_id)
    logger.debug "In get_report_participant_relationships_for_participant id:#{participant_id}"
    found_relationships = Array.new
    self.report_participant_relationships.each do |ri|
      logger.debug "COMPARING #{ri.participant_id} TO #{participant_id}"
      if ri.participant_id == participant_id
        found_relationships << ri
        
      end
    end
    return found_relationships
  end
  
  
  
  def destroy_participants
    report_participant_relationships.each do |ri|
      ri.destroy
    end
  end
  
  
  
  def get_specific_report_student_relationship(participant_id, relationship_id)
    self.report_participant_relationships.each do |ri|
      if ri.participant_id == participant_id && ri.relationship_to_report_id == relationship_id
        return ri
      end
    end
    return nil
  end
  
  #return true if participant is associated with report
  def associated?(participant) 
  logger.debug("TEST associated for #{participant.id} current participants #{participant_ids} RESULT #{participant_ids.include?(participant.id)}")
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
  
  
  
  def add_default_relationship_for_participant(participant_id)
    # only want to add if fyi doesn't already exist
    all_relationships_for_participant = get_report_participant_relationships_for_participant(participant_id)
    
    # only want to add if no relationships exist
    if all_relationships_for_participant.count == 0
      ri = ReportParticipantRelationship.new(:participant_id => participant_id)
      if self.is_a? MaintenanceReport
        ri.relationship_to_report_id = RelationshipToReport.maintenance_concern
      end
      self.report_participant_relationships << ri
    else
      ri = get_specific_report_student_relationship(participant_id, RelationshipToReport.fyi) 
    end
    return ri
  end
  
  
  
  def add_specific_relationship_to_report_for_participant(participant_id, relationship_id)
    ri = get_specific_report_student_relationship(participant_id, relationship_id) 
    
    if ri == nil
      ri = ReportParticipantRelationship.new(:participant_id => participant_id, :relationship_to_report_id => relationship_id)
      self.report_participant_relationships << ri
    end
    
    return ri
  end
  
  
  
  def add_default_report_student_relationships_for_participant_array(participants)    
    if participants != nil
      # go through the students and add fyi relationships
      participants.each do |s|
        add_default_relationship_for_participant(s.id)
      end
    end
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
   
  
  def process_participant_params_string_from_student_search(participants_string)
    if participants_string !=nil
      participants = participants_string.split(/,/)
      participants.each do |p|
        self.add_default_relationship_for_participant(Integer(p))
      end
    end
  end
  
   private
   def tag_datetime
  	   (approach_time != nil ? approach_time : created_at).strftime("%Y%m%d-%H%M")
  end
  
end
