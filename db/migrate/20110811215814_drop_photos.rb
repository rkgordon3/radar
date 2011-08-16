class DropPhotos < ActiveRecord::Migration
  def self.up
    drop_table "photos"
  end

  def self.down
  end
end
