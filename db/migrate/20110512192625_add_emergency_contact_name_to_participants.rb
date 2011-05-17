class AddEmergencyContactNameToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :emergency_contact_name, :string
  end

  def self.down
    remove_column :participants, :emergency_contact_name
  end
end
