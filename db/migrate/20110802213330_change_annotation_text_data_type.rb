class ChangeAnnotationTextDataType < ActiveRecord::Migration
  def self.up
    change_column :annotations, :text, :text, :limit => 4000000000
  end

  def self.down
    change_column :annotations, :text, :text
  end
end
