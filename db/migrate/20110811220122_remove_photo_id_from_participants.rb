class RemovePhotoIdFromParticipants < ActiveRecord::Migration
  def self.up
    remove_column :participants, :photo_id
  end

  def self.down
    add_column :participants, :photo_id, :integer
  end
end
