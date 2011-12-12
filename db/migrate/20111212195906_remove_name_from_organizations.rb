class RemoveNameFromOrganizations < ActiveRecord::Migration
  def self.up
    remove_column :organizations, :name
  end

  def self.down
    add_column :organizations, :name, :string
  end
end
