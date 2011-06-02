class CreateStaffOrganizations < ActiveRecord::Migration
  def self.up
    create_table :staff_organizations do |t|
      t.integer :staff_id
      t.integer :organization_id

      t.timestamps
    end
  end

  def self.down
    drop_table :staff_organizations
  end
end
