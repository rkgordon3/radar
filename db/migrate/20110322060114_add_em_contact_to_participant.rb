class AddEmContactToParticipant < ActiveRecord::Migration
  def self.up
    add_column :participants, :emContact, :string
  end

  def self.down
    remove_column :participants, :emContact
  end
end
