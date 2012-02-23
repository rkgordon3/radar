class TutorReport < Report
	def default_contact_duration
		60
	end
	
  # Return approach time format for Anytime.Pick
  # This over-rides value in report
  # Eventually move this to ReportType table??
  def approach_time_format
    "%b %e, %Y"
  end
  
    
  def approach_time_format_picker
	approach_time_format
  end
  
  def default_sort_field
    "created_at DESC"
  end
end
