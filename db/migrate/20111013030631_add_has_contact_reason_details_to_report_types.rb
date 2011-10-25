class AddHasContactReasonDetailsToReportTypes < ActiveRecord::Migration
  def self.up
    add_column :report_types, :has_contact_reason_details, :boolean
  end

  def self.down
    remove_column :report_types, :has_contact_reason_details
  end
end
