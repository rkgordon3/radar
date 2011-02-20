class AddTypeToReportsAgain2 < ActiveRecord::Migration
  def self.up
  	  add_column :reports, :type, :string
  end

  def self.down
  end
end
