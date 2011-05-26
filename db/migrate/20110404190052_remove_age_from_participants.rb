class RemoveAgeFromParticipants < ActiveRecord::Migration
  def self.up
	remove_column :participants, :age
  end

  def self.down
	add_column :participants, :age, :string
  end
end
