class AddEmailToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :email, :string
  end

  def self.down
    remove_column :participants, :email
  end
end
