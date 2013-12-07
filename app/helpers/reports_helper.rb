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
   "report[participant][#{participant.id}][#{infraction.id}]" 
  end

  def participant_row_id(participant_count)
    (participant_count-1)/ReportsHelper::REPORT_COLUMNS
  end

  def participant_in_report_id(participant) 
    "p-in-report-#{participant.id}"
  end
end
