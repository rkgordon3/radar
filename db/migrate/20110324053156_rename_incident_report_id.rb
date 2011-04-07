class RenameIncidentReportId < ActiveRecord::Migration
  def self.up
    rename_column :report_participant_relationships, :incident_report_id, :report_id
  end

  def self.down
  end
end
