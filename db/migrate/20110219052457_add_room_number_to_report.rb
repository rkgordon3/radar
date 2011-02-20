class AddRoomNumberToReport < ActiveRecord::Migration
  def self.up
  	  add_column :reports, :room_number, :string
  
  end

  def self.down
  end
end
