class CreateStudentInfractions < ActiveRecord::Migration
  def self.up
    create_table :student_infractions do |t|
      t.datetime :time
      t.integer :report_id
      t.integer :infraction_id
      t.integer :student_id
      t.timestamps
    end
  end                               

  def self.down
    drop_table :student_infractions
  end
end
