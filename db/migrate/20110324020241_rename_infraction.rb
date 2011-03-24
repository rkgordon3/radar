class RenameInfraction < ActiveRecord::Migration
  def self.up
    rename_table :infractions, :relationship_to_report
  end

  def self.down
    rename_table :relationship_to_report, :infractions
  end
end
