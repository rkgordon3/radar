class CreateNotificationPreferences < ActiveRecord::Migration
  def self.up
    create_table :notification_preferences do |t|
      t.integer :staff_id
      t.string :report_type
      t.integer :frequency
      t.integer :time_offset
      t.integer :scope

      t.timestamps
    end
  end

  def self.down
    drop_table :notification_preferences
  end
end
