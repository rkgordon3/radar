class AddContactDurationToReportParticipants < ActiveRecord::Migration
  def self.up
    add_column :report_participants, :contact_duration, :integer
  end

  def self.down
    remove_column :report_participants, :contact_duration
  end
end
