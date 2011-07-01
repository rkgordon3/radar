class AddForwardableToReportTypes < ActiveRecord::Migration
  def self.up
    add_column :report_types, :forwardable, :boolean
  end

  def self.down
    remove_column :report_types, :forwardable
  end
end
