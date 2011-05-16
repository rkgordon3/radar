class AddClassificationParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :classification, :string
  end

  def self.down
    remove_column :participants, :classification, :string
  end
end
