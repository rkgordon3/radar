class StaffsChangeRoleToAccessLevelIntege < ActiveRecord::Migration
  def self.up
    remove_column :staffs, :role
    add_column :staffs, :access_level, :integer
  end

  def self.down
  end
end
