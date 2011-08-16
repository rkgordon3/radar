class AddIsResidenceHallToBuilding < ActiveRecord::Migration
  def self.up
     change_table :buildings do |t|
	    t.boolean :is_residence, :default=>false
      end
	  Building.update_all ["is_residence = ?", false]
  end

  def self.down
	remove_column :buildings, :is_residence
  end
end
