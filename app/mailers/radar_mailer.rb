class RadarMailer < ActionMailer::Base
  default :from => "radar@smumn.edu"
  
  def notification_mail(reports, staff)
    @reports = reports
    @reports_keys = reports.keys
    #path = @report.class.name.tableize
    
    #@report_url = "http://140.190.71.162:3000/"+path+"/"+report.id.to_s
    
    @first_name = staff.first_name
    @last_name = staff.last_name	
    
    mail(:to => staff.email, :subject => "RADAR Update: "+ Time.now.to_s(:my_time)) 
  end
  
  def report_mail(report, emails, staff)
    @report = report
    @first_name = staff.first_name
    @last_name = staff.last_name
    mail(:to => emails, :subject => "RADAR #{@report.display_name} : " + @report.tag) do |format|
	    format.html { render @report.type.tableize.singularize.+"_mail" }
=begin
      if @report.type == "IncidentReport"
        #format.text {render 'incident_report_mail'}
        format.html {render 'incident_report_mail'}
      elsif @report.type == "MaintenanceReport"
        #format.text {render 'maintenance_report_mail'}
        format.html {render 'maintenance_report_mail'}
      elsif @report.type == "Note"
        # Do Something...
      elsif @report.type == "Report"
        # Do Something...
      end
=end
    end
  end
  
  
end
