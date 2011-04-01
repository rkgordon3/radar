class AddStaffsActiveForReal < ActiveRecord::Migration
  def self.up
    add_column :staffs, :active, :boolean
  end

  def self.down
  end
end
