class AddReportFkToAnnotation < ActiveRecord::Migration
  def self.up
    add_column :annotations, :report_id, :integer
  end

  def self.down
    remove_column :annotations, :report_id
end
end
