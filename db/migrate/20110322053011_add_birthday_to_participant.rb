class AddBirthdayToParticipant < ActiveRecord::Migration
  def self.up
    add_column :participants, :birthday, :datetime
  end

  def self.down
    remove_column :participants, :birthday
  end
end
