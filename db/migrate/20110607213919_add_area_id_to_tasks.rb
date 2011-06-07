class AddAreaIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :area_id, :integer
  end

  def self.down
    remove_column :tasks, :area_id
  end
end
