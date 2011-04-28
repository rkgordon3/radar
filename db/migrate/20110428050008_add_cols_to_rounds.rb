class AddColsToRounds < ActiveRecord::Migration
  def self.up
	add_column :rounds, :shift_id, :integer
	add_column :rounds, :end_time, :datetime
  end

  def self.down
  end
end
