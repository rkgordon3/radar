class RadarMailer < ActionMailer::Base
  default :from => "radar@smumn.edu"
  
  def immediate_notification_mail(report, staff)
	@report_type = report.type
	@report_url = "http://140.190.71.162:3000/incident_reports/"+report.id.to_s
	
	@first_name = staff.first_name
	@last_name = staff.last_name	
	mail(:to => staff.email, :subject => "Incident Report Submitted")
	puts "Mailed "+staff.email
	
	end
end
