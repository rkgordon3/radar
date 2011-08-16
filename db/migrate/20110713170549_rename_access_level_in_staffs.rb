class RenameAccessLevelInStaffs < ActiveRecord::Migration
  def self.up
    rename_column :staffs, :access_level, :access_level_id
  end

  def self.down
    rename_column :staffs, :access_level_id, :access_level
  end
end
