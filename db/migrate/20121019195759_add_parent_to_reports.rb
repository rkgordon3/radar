class AddParentToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :parent_id, :integer
  end

  def self.down
    remove_column :reports, :parent_id
  end
end
