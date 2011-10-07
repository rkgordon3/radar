class AddSubmitOnMobileToReportTypes < ActiveRecord::Migration
  def self.up
    add_column :report_types, :submit_on_mobile, :boolean
  end

  def self.down
    remove_column :report_types, :submit_on_mobile
  end
end
