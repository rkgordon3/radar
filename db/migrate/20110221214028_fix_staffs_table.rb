class FixStaffsTable < ActiveRecord::Migration
  def self.up
		add_column :staffs, :first_name, :string
		add_column :staffs, :last_name, :string
		add_column :staffs, :role, :string
  end

  def self.down
  end
end
