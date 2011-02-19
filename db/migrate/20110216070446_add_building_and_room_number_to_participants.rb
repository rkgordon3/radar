class AddBuildingAndRoomNumberToParticipants < ActiveRecord::Migration
  def self.up
  	  add_column :participants, :room_number, :string
  	  add_column :participants, :building, :string
  end

  def self.down
  end
end
