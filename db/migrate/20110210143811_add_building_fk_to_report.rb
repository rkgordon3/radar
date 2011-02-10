class AddBuildingFkToReport < ActiveRecord::Migration
  def self.up
    add_column :reports, :building_id, :integer
  end

  def self.down
    remove_column :reports, :building_id
  end
end
