class RemoveReportIdFromInterestedParties < ActiveRecord::Migration
  def self.up
    remove_column :interested_parties, :report_id
  end

  def self.down
    add_column :interested_parties, :report_id, :integer
  end
end
