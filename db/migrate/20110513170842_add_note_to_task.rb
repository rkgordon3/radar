class AddNoteToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :note, :string
  end

  def self.down
    remove_column :tasks, :note
  end
end
