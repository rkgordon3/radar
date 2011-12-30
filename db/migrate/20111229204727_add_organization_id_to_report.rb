class AddOrganizationIdToReport < ActiveRecord::Migration
  def self.up
    add_column :reports, :organization_id, :integer
  end

  def self.down
    remove_column :reports, :organization_id
  end
end
