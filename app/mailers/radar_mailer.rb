class RadarMailer < ActionMailer::Base
  default :from => "radar@smumn.edu"
  
  def notification_mail(reports, staff)
	@reports = reports
	@reports_keys = reports.keys
	#path = @report.class.name.tableize

	#@report_url = "http://140.190.71.162:3000/"+path+"/"+report.id.to_s
	
	@first_name = staff.first_name
	@last_name = staff.last_name	
	
	  mail(:to => staff.email, :subject => "RADAR Update: "+ Time.now.to_s) 
  
	
	end
end
