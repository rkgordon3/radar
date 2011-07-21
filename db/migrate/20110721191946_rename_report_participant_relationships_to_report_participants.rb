class RenameReportParticipantRelationshipsToReportParticipants < ActiveRecord::Migration
  def self.up
    rename_table :report_participant_relationships, :report_participants
  end

  def self.down
  end
end
