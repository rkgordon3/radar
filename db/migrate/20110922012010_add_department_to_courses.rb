class AddDepartmentToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :department, :string
  end

  def self.down
    remove_column :courses, :department
  end
end
