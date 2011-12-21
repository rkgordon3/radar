class AddReasonContextToReportTypes < ActiveRecord::Migration
  def self.up
    add_column :report_types, :reason_context, :string
  end

  def self.down
    remove_column :report_types, :reason_context
  end
end
