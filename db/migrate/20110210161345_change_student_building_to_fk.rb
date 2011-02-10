class ChangeStudentBuildingToFk < ActiveRecord::Migration
  def self.up
  	  change_table :students do |t|
  	  	  t.remove :building
  	  	  t.integer :building_id
  	  end
  end

  def self.down
  end
end
