class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
    	    t.string :first_name
    	    t.string :last_name
    	    t.string :middle_initial
    	    t.integer :room_number
            t.integer :age

      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
