class AddSemesterToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :semester, :string
  end

  def self.down
    remove_column :courses, :semester
  end
end
