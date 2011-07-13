class AddDisplayNameToAccessLevels < ActiveRecord::Migration
  def self.up
    add_column :access_levels, :display_name, :string
  end

  def self.down
    remove_column :access_levels, :display_name
  end
end
