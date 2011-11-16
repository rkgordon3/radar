class AddIndexableToReportFields < ActiveRecord::Migration
  def self.up
    add_column :report_fields, :indexable, :integer
  end

  def self.down
    remove_column :report_fields, :indexable
  end
end
