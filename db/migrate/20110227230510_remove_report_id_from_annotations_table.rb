class RemoveReportIdFromAnnotationsTable < ActiveRecord::Migration
  def self.up
  	  remove_column :annotations, :report_id
  end

  def self.down
  end
end
