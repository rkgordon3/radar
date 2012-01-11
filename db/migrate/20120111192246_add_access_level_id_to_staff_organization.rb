class AddAccessLevelIdToStaffOrganization < ActiveRecord::Migration
  def self.up
    add_column :staff_organizations, :access_level_id, :integer
  end

  def self.down
    remove_column :staff_organizations, :access_level_id
  end
end
