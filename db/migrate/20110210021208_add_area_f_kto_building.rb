class AddAreaFKtoBuilding < ActiveRecord::Migration
  def self.up
  	  change_table :buildings do |t|
  	  t.references :area
  end
  end

  def self.down
  	  raise IrreversibleMigration 
  end
end
