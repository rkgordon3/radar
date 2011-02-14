class RemoveTypeFromReports < ActiveRecord::Migration
  def self.up
  	  remove_column :reports, :type
  end

  def self.down
  end
end
