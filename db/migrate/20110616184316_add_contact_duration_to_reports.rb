class AddContactDurationToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :contact_duration, :datetime
  end

  def self.down
    remove_column :reports, :contact_duration
  end
end
