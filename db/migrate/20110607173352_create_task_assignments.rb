class CreateTaskAssignments < ActiveRecord::Migration
  def self.up
    create_table :task_assignments do |t|
      t.integer :shift_id
      t.integer :task_id
      t.boolean :done

      t.timestamps
    end
  end

  def self.down
    drop_table :task_assignments
  end
end
