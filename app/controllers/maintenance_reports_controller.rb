class MaintenanceReportsController < ReportsController
				
				def new
								@report = MaintenanceReport.new(:staff_id => current_staff.id)
								session[:report] = @report
								respond_to do |format|
												format.html
								end
				end
end
