class HomeController < ApplicationController

  
  def landingpage
    if staff_signed_in?
      @unsubmitted = IncidentReport.accessible_by(current_ability).where(:submitted => false, :staff_id => current_staff.id)
      @unsubmitted = Report.sort(@unsubmitted,params[:sort])
      @report_type = ReportType.find_by_name("IncidentReport")
      @recent = IncidentReport.accessible_by(current_ability).where(:created_at => (current_staff.last_sign_in_at)..(Time.now), :submitted => true)
      @recent = Report.sort(@recent,params[:sort])
    end
  
    respond_to do |format|
      format.html
      format.xml
      format.iphone {render :layout => 'mobile_application'}
      format.js
    end
  end
  
end