module ReportsHelper
  REPORT_COLUMNS = 3
  
  def columns
    REPORT_COLUMNS
  end
  
  def display_common_reasons?(report)  
	 (report.supports_selectable_contact_reasons?) and (report.number_of_participants > 1)
  end
end
