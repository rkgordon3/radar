class AddOrganizationIdToRelationshipToReport < ActiveRecord::Migration
  def self.up
    add_column :relationship_to_reports, :organization_id, :integer
  end

  def self.down
    remove_column :relationship_to_reports, :organization_id
  end
end
