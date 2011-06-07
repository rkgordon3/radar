class CreateStaffAreas < ActiveRecord::Migration
  def self.up
    create_table :staff_areas do |t|
      t.integer :staff_id
      t.integer :area_id

      t.timestamps
    end
  end

  def self.down
    drop_table :staff_areas
  end
end
