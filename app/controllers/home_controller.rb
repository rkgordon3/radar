class HomeController < ApplicationController

  
  def landingpage
    if staff_signed_in?
      @unsubmitted = Report.accessible_by(current_ability).where(:submitted => false, :staff_id => current_staff.id)
      @unsubmitted = @unsubmitted.order("reports.#{Report.default_sort_field} DESC")
      #@report_type = ReportType.find_by_name("IncidentReport")
      @recent = Report.accessible_by(current_ability).where(:created_at => (current_staff.last_sign_in_at)..(Time.now), :submitted => true)
      @recent = @recent.order("reports.#{Report.default_sort_field} DESC")
    end
  
    respond_to do |format|
      format.html
      format.xml
      format.iphone {render :layout => 'mobile_application'}
      format.js
    end
  end
  
end