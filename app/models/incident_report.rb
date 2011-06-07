class IncidentReport < Report

 def supports_selectable_contact_reasons?
    true
  end

  def can_edit_from_mobile?
	true
  end
  
 def add_contact_reason(params)
    # create arrays for the new reported infractions
    new_ris = Array.new
    old_ris = Array.new
    
    report_participant_relationships.each do |ri|
      old_ris << ri
    end
    
    #create array for the participants we have
    participants = get_all_participants
    
    # begin loop for each participant
    participants.each do |p|
      # variable to see if we have found an infraction for p
      any_relationship_to_report_found_for_participant = false 
     
      # example: if the user wants student 6 to have infraction 1 (community disruption) and 3
      # param entry would look like params[6] = { "3" => "on", "6" => "on" }
        if params[p.to_s()] != nil
        				params[p.to_s()].each_key { |key| 
        								logger.debug("Found infraction #{key} for #{p}")
        								any_relationship_to_report_found_for_participant = true
        								new_ris << add_specific_relationship_to_report_for_participant(p, key.to_i)
        				}
        end
      #end
      
      # if there are no checkboxes checked for particpant
      if any_relationship_to_report_found_for_participant == false
        new_ris << add_default_relationship_for_participant(p)
      end
    end
    
    # destroy all old rep. inf.s if they are not in new list
    old_ris.each do |ori|
      if !new_ris.include?(ori)
        ori.report_id = 0 # make sure connection is broken
        ori.destroy
      end
    end
    
    # save new ris to report
   report_participant_relationships = new_ris
    
  end
  
end
