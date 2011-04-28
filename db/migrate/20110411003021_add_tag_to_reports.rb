class AddTagToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :tag, :string
  end

  def self.down
    remove_column :reports, :tag
  end
end
