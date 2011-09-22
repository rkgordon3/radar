class AddSectionToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :section, :string
  end

  def self.down
    remove_column :courses, :section
  end
end
