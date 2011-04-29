class AddColumnsToShifts < ActiveRecord::Migration
  def self.up
	add_column :shifts, :staff_id, :integer
	add_column :shifts, :time_out, :datetime
  end

  def self.down
  end
end
