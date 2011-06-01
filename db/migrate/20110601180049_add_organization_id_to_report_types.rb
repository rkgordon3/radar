class AddOrganizationIdToReportTypes < ActiveRecord::Migration
  def self.up
    add_column :report_types, :organization_id, :integer
  end

  def self.down
    remove_column :report_types, :organization_id
  end
end
