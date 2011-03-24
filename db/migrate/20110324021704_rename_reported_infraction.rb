class RenameReportedInfraction < ActiveRecord::Migration
  def self.up
    rename_table :reported_infractions, :report_participant_relationships
  end

  def self.down
  end
end
