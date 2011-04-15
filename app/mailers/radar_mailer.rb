class RadarMailer < ActionMailer::Base
  default :from => "radar@smumn.edu"
  
  def immediate_notification_mail(report, staff)
	@report = report
	path = @report.class.name.tableize

	@report_url = "http://140.190.71.162:3000/"+path+"/"+report.id.to_s
	
	@first_name = staff.first_name
	@last_name = staff.last_name	
	
	  mail(:to => staff.email, :subject => @report.display_name+" Submitted") 
	  puts "Mailed "+staff.email
  
	
	end
end
