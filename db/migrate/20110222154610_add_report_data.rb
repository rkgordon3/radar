class AddReportData < ActiveRecord::Migration
  def self.up
	change_table :reports do |t|
		t.datetime :approach_time
		t.string :annotation
		t.string :submitter
		t.string :location
	end
  end

  def self.down
	remove_column :reports, :approach_time
	remove_column :reports, :annotation
	remove_column :reports, :submitter
	remove_column :reports, :location
  end
end
