class AddLastNotifiedToNotificationPreferences < ActiveRecord::Migration
  def self.up
	add_column :notification_preferences, :last_notified, :datetime
  end

  def self.down
  end
end
