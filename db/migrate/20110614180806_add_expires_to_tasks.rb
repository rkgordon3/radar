class AddExpiresToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :expires, :boolean
  end

  def self.down
    remove_column :tasks, :expires
  end
end
