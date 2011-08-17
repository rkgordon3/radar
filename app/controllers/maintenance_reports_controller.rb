class MaintenanceReportsController < ReportsController
  load_and_authorize_resource
  
  def new
    @report = MaintenanceReport.new(:staff_id => current_staff.id)
    super
  end

  def index
    @report = @maintenance_report
    super
  end

  def show
    @report = @maintenance_report
    super
  end

  def edit
    @report = @maintenance_report
    super
  end

  def update
    @report = @maintenance_report
    super
  end

  def destroy
    @report = @maintenance_report
    super
  end

end
