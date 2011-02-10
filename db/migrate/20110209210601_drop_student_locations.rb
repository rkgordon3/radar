class DropStudentLocations < ActiveRecord::Migration
  def self.up
  	  drop_table :student_infractions
  	  drop_table :report_locations
  end

  def self.down
  end
end
