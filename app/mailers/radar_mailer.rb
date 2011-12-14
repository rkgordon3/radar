class RadarMailer < ActionMailer::Base
  default :from => "radar@smumn.edu"
  # reports is a hash report_display_name => report
  def notification_mail(reports, staff)
    @reports = reports
    @reports_keys = reports.keys
    
    @first_name = staff.first_name
    @last_name = staff.last_name	
	
	# This is an AF kludge...need to revisit
	subject = reports.size > 1 ? "Radar Digest" : "Radar #{reports.first[1][0].display_name} #{reports.first[1][0].tag} (#{reports.first[1][0].staff.name})"
    
    mail(:to => staff.email, :subject => "#{subject}: " + Time.now.to_s(:my_time)) 
  end
  
  def report_mail(report, emails, staff)
    @report = report
    @first_name = staff.first_name
    @last_name = staff.last_name
    mail(:to => emails, :subject => "RADAR #{@report.display_name} : " + @report.tag) do |format|
	    format.html { render @report.type.tableize.singularize.+"_mail" }
    end
  end

  def generic_mail(subject, message, email)
    @message = message
    mail(:to => email, :subject => subject) do |format|
	    format.html { render "generic_mail" }
    end
  end
  
end
