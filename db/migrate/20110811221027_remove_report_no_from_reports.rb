class RemoveReportNoFromReports < ActiveRecord::Migration
  def self.up
    remove_column :reports, :report_no
  end

  def self.down
    add_column :reports, :report_no, :string
  end
end
