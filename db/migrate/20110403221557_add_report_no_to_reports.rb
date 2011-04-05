class AddReportNoToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :report_no, :string
  end

  def self.down
    remove_column :reports, :report_no
  end
end
