class AddEndDateToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :end_date, :datetime
  end

  def self.down
    remove_column :tasks, :end_date
  end
end
