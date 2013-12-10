module ReportsHelper
  REPORT_COLUMNS = 3
  
  def columns
    REPORT_COLUMNS
  end
  
  def display_common_reasons?(report)  
	 (report.supports_selectable_contact_reasons?) and (report.number_of_participants > 1)
  end


  def supports_selectable_reasons?(report_type)  
   ReportType.find_by_name(report_type).selectable_contact_reasons?
  end




  def report_index_id(report)
    "report-"+report.id.to_s
  end

  def reason_name(participant, infraction)
   "report[reasons][#{participant.id}][#{infraction.id}]" 
  end

  def common_reason_name(infraction) 
    "common-reason[#{infraction.id}]"
  end

  def reason_id(participant, infraction) 
    pid = (participant.kind_of? Participant) ? participant.id : participant
    infid = (infraction.kind_of? RelationshipToReport) ? infraction.id : infraction
    "reason-#{infid}-#{pid}"
  end

  def common_reason_id(infraction)
    "common-reason-#{infraction.id}"
  end

  def participant_row_id(participant_count)
    (participant_count-1)/ReportsHelper::REPORT_COLUMNS
  end

  # Generaate an ID for a participant in a report
  # If input is a ActiveRecord model, use id, else treat input
  # as an ID 
  def participant_in_report_id(participant) 
    id = (participant.kind_of? Participant) ? participant.id : participant
    "p-in-report-#{id}"
  end


  # Return reasons supported by a particular report type
  def supported_reasons(report_type)
    ReportType.find_by_name(report_type).associated_reasons(nil)
  end


  def participant_reason_link_id(participant)
    id = (participant.kind_of? Participant) ? participant.id : participant
    "p-reason-#{id}"
  end


end
