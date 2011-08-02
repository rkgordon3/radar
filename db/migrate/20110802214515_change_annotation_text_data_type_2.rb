class ChangeAnnotationTextDataType2 < ActiveRecord::Migration
  def self.up
    change_column :annotations, :text, :text, :limit => 20.kilobytes
  end

  def self.down
    change_column :annotations, :text, :text, :limit => 4000000000
  end
end
