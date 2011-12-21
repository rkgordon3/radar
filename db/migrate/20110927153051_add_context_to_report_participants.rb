class AddContextToReportParticipants < ActiveRecord::Migration
  def self.up
    add_column :report_participants, :context, :string
  end

  def self.down
    remove_column :report_participants, :context
  end
end
