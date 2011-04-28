class AddFullNameToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :full_name, :string
  end

  def self.down
    remove_column :participants, :full_name
  end
end
