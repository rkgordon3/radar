class CreateBuildings < ActiveRecord::Migration
  def self.up
    create_table :buildings do |t|
      t.string :name
      t.string :abbreviation
      t.integer :area_id

      t.timestamps
    end
  end

  def self.down
    drop_table :buildings
  end
end
