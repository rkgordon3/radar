class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

FactoryGirl.create(:area, :name => UNSPECIFIED_AREA)

FactoryGirl.create(:report_type, :name => "IncidentReport", :display_name => "Incident Report", :abbreviation => "IR")
FactoryGirl.create(:report_type, :name => "MaintenanceReport", :display_name => "Maintenance Report")