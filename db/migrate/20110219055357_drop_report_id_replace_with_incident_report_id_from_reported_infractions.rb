class DropReportIdReplaceWithIncidentReportIdFromReportedInfractions < ActiveRecord::Migration
  def self.up
  	  remove_column :reported_infractions, :report_id
  	  add_column :reported_infractions, :incident_report_id, :string
  end

  def self.down
  end
end
