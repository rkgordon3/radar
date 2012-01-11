class RemoveIdFromStaffOrganization < ActiveRecord::Migration
  def self.up
   remove_column :staff_organizations, :id
  end

  def self.down
    add_column :staff_organizations, :id, :integer, :primary_key => true
  end
end
