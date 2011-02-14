class AddAbreviationToAreas < ActiveRecord::Migration
  def self.up
  	  add_column :areas, :abbreviation, :string
  end

  def self.down
  end
end
