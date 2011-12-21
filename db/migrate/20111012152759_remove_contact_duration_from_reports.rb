class RemoveContactDurationFromReports < ActiveRecord::Migration
  def self.up
    remove_column :reports, :contact_duration
  end

  def self.down
  end
end
