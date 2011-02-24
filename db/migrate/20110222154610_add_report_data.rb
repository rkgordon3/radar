class AddReportData < ActiveRecord::Migration
  def self.up
	
  end

  def self.down
	remove_column :reports, :approach_time
	remove_column :reports, :annotation
	remove_column :reports, :submitter
	remove_column :reports, :location
  end
end
