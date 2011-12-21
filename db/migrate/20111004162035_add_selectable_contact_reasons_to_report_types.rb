class AddSelectableContactReasonsToReportTypes < ActiveRecord::Migration
  def self.up
    add_column :report_types, :selectable_contact_reasons, :boolean
  end

  def self.down
    remove_column :report_types, :selectable_contact_reasons
  end
end
