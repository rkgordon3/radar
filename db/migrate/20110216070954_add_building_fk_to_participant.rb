class AddBuildingFkToParticipant < ActiveRecord::Migration
  def self.up
  	  change_table :participants do |t|
  	  	  t.references :building
  	  end
  end

  def self.down
  end
end
