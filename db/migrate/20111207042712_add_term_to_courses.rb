class AddTermToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :term, :string
  end

  def self.down
    remove_column :courses, :term
  end
end
