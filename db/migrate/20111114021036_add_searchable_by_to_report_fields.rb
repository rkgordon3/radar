class AddSearchableByToReportFields < ActiveRecord::Migration
  def self.up
    add_column :report_fields, :searchable_by, :boolean
  end

  def self.down
    remove_column :report_fields, :searchable_by
  end
end
