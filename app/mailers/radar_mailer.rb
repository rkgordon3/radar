class RadarMailer < ActionMailer::Base
  default :from => "radar@smumn.edu"
  
  def notification_mail(reports, staff)
    @reports = reports
    @reports_keys = reports.keys
    
    @first_name = staff.first_name
    @last_name = staff.last_name	
	
	subject = reports.size > 1 ? "Radar Digest" : "Radar #{reports[0].display_name} #{reports[0].tag}"
    
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
  
  
end
