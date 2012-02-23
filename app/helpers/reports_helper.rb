module ReportsHelper
  REPORT_COLUMNS = 3
  
  def columns
    REPORT_COLUMNS
  end
  
  def display_common_reasons?(report)
	(report.participant_ids.size > 1) and (report.supports_selectable_contact_reasons?)
  end
end
