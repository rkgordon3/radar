class AddStudentIdToEnrollments < ActiveRecord::Migration
  def self.up
    add_column :enrollments, :student_id, :string
  end

  def self.down
    remove_column :enrollments, :student_id
  end
end
