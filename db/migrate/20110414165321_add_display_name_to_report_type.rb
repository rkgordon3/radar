class AddDisplayNameToReportType < ActiveRecord::Migration
  def self.up
	add_column :report_types, :display_name, :string
  end

  def self.down
  end
end
