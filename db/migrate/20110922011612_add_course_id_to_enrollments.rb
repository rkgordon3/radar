class AddCourseIdToEnrollments < ActiveRecord::Migration
  def self.up
    add_column :enrollments, :course_id, :string
  end

  def self.down
    remove_column :enrollments, :course_id
  end
end
