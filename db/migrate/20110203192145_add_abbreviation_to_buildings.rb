class AddAbbreviationToBuildings < ActiveRecord::Migration
  def self.up
    add_column :buildings, :abbreviation, :string
  end

  def self.down
    remove_column :buildings, :abbreviation
  end
end
