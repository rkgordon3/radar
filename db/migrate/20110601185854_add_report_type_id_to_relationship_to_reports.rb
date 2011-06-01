class AddReportTypeIdToRelationshipToReports < ActiveRecord::Migration
  def self.up
    add_column :relationship_to_reports, :report_type_id, :integer
  end

  def self.down
    remove_column :relationship_to_reports, :report_type_id
  end
end
