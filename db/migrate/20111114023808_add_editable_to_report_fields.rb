class AddEditableToReportFields < ActiveRecord::Migration
  def self.up
    add_column :report_fields, :editable, :boolean
  end

  def self.down
    remove_column :report_fields, :editable
  end
end
