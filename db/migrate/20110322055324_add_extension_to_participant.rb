class AddExtensionToParticipant < ActiveRecord::Migration
  def self.up
    add_column :participants, :extension, :string
  end

  def self.down
    remove_column :participants, :extension
  end
end
