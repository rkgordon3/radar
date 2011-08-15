class AddNumericLevelToAccessLevel < ActiveRecord::Migration
  def self.up
    add_column :access_levels, :numeric_level, :integer
  end

  def self.down
    remove_column :access_levels, :numeric_level
  end
end
