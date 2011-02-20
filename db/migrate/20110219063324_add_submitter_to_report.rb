class AddSubmitterToReport < ActiveRecord::Migration
  def self.up
  	  add_column :reports, :submitter, :integer
  
  end

  def self.down
  end
end
