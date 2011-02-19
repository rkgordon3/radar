class AddTypeToReport < ActiveRecord::Migration
  def self.up
  	  add_column :reports, :type, :string
  end

  def self.down
  	  remove_column :reports, :type, :string
  end
end
