class DeleteSubmitterFieldInReports < ActiveRecord::Migration
  def self.up
  	  remove_column :reports, :submitter
  end

  def self.down
  end
end
