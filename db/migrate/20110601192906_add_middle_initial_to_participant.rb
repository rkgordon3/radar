class AddMiddleInitialToParticipant < ActiveRecord::Migration
  def self.up
    add_column :participants, :middle_initial, :character
  end

  def self.down
    remove_column :participants, :middle_initial
  end
end
