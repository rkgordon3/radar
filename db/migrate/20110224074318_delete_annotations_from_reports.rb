class DeleteAnnotationsFromReports < ActiveRecord::Migration
  def self.up
  	  remove_column :reports, :annotation
  end

  def self.down
  end
end
