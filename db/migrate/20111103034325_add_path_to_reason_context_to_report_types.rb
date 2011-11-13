class AddPathToReasonContextToReportTypes < ActiveRecord::Migration
  def self.up
    add_column :report_types, :path_to_reason_context, :string
  end

  def self.down
    remove_column :report_types, :path_to_reason_context
  end
end
