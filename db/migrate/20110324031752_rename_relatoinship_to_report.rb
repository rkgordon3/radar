class RenameRelatoinshipToReport < ActiveRecord::Migration
  def self.up
    rename_table :relationship_to_report, :relationship_to_reports
  end

  def self.down
  end
end
