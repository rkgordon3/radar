class RenameInfractionIdInReportParticpantRelationships < ActiveRecord::Migration
  def self.up
    rename_column :report_participant_relationships, :infraction_id, :relationship_to_report_id
  end

  def self.down
  end
end
