CALL="call"
DUTY="duty"



def level_ids_from_names(list) 
	AccessLevel.where(:display_name => list).collect { |al| al.id }
end


#DUTY_LOG_LEVELS = level_ids_from_names(['Resident Assistant','Staff'])
#CALL_LOG_LEVELS = level_ids_from_names(['Hall Director', 'Supervisor'])

