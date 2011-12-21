class RemoveSearchableByEditableAndIndexableColumnsFromReportFields < ActiveRecord::Migration
  def self.up
    remove_column :report_fields, :searchable_by
    remove_column :report_fields, :editable
    remove_column :report_fields, :indexable
  end

  def self.down
  end
end
