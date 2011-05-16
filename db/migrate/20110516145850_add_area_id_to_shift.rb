class AddAreaIdToShift < ActiveRecord::Migration
  def self.up
    add_column :shifts, :area_id, :integer
  end

  def self.down
    remove_column :shifts, :area_id
  end
end
