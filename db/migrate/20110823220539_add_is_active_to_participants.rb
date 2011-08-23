class AddIsActiveToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :is_active, :boolean, :default=>true
  end

  def self.down
    remove_column :participants, :is_active

  end
end
