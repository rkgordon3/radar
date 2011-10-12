class AddAnnotationIdToReportParticipants < ActiveRecord::Migration
  def self.up
    add_column :report_participants, :annotation_id, :integer
  end

  def self.down
    remove_column :report_participants, :annotation_id
  end
end
