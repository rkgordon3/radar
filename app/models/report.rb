class Report < ActiveRecord::Base
	belongs_to  	:staff
	belongs_to    :building
	has_one		    :annotation
  has_many      :report_participant_relationships
  belongs_to    :annotation
  after_initialize :setup_defaults
  after_save       :save_everything
  before_destroy   :destroy_everything
  
  
  def annotation_text
  				if annotation != nil
  								annotation.text
  				else
  								nil
  				end
  end
	def update_attributes_and_save(params)
					update_attributes_without_saving(params)
					valid?
					save
	end
	
  def update_attributes_without_saving(params)
  				logger.debug "IN REPORT.update attributes  params #{params}"
    self.building_id = params[:building_id]
    self.room_number = params[:room_number]
    self.approach_time = params[:approach_time] 
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
  					logger.debug " save report annotation : #{annotation}"
  		self.annotation_id = annotation.id
  	end
  	super
  end
  
  def save_everything
    # save each reported infraction to database  
    self.report_participant_relationships.each do |ri|
      if !ri.frozen?                                # make sure the reported infraction isn't frozen
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
 				 logger.debug("REPORT destory_participants")
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
  
  
  
  
  def get_all_participants
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
	tag = ReportType.find_by_name(self.class.name).abbreviation + "-" + approach_time.strftime("%Y%m%d-%H%M") + "-" + staff_id.to_s 
  end

  
end


