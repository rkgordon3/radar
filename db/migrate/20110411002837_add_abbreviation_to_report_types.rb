class AddAbbreviationToReportTypes < ActiveRecord::Migration
  def self.up
    add_column :report_types, :abbreviation, :string
  end

  def self.down
    remove_column :report_types, :abbreviation
  end
end
