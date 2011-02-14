class AddAbreviationToBuildings < ActiveRecord::Migration
  def self.up
  	  add_column :buildings, :abbreviation, :string
  end

  def self.down
  end
end
