class AddReportTypeIdToInterestedParties < ActiveRecord::Migration
  def self.up
    add_column :interested_parties, :report_type_id, :integer
  end

  def self.down
    remove_column :interested_parties, :report_type_id
  end
end
