class AddTimeToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :time, :integer
  end

  def self.down
    remove_column :tasks, :time
  end
end
