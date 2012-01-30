class AddDefaultReasonIdToReportTypes < ActiveRecord::Migration
  def self.up
    add_column :report_types, :default_reason_id, :integer
  end

  def self.down
    remove_column :report_types, :default_reason_id
  end
end
