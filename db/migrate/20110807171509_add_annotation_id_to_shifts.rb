class AddAnnotationIdToShifts < ActiveRecord::Migration
  def self.up
    add_column :shifts, :annotation_id, :integer
  end

  def self.down
    remove_column :shifts, :annotation_id
  end
end
