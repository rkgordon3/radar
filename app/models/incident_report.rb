class IncidentReport < Report
  has_many 	:reported_infractions
  belongs_to	:annotation
  
  def update_attributes_without_saving(params)
    self.building_id = params[:incident_report][:building_id]
    self.room_number = params[:incident_report][:room_number]
    self.approach_time = params[:incident_report][:approach_time]   
  end
  
  def after_initialize
    if self.id == nil
      self.building_id = Building.unspecified
      self.approach_time = Time.now
    end
  end
  
  def after_save
    # save each reported infraction to database
    self.reported_infractions.each do |ri|
      if !ri.frozen?                                # make sure the reported infraction isn't frozen
        ri.incident_report_id = self.id # establish connection
        ri.save                                     # actually save
      end
    end
  end
  
  def get_reported_infractions_for_participant(participant_id)
    found_reported_infractions = Array.new
    self.reported_infractions.each do |ri|
      if ri.participant_id == participant_id
        found_reported_infractions << ri
      end
    end
    return found_reported_infractions
  end
  
  def get_specific_reported_infraction_for_participant(participant_id, infraction_id)
    self.reported_infractions.each do |ri|
      if ri.participant_id == participant_id && ri.infraction_id == infraction_id
        return ri
      end
    end
    return nil
  end
  
end
