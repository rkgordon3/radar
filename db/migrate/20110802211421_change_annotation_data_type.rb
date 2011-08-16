class ChangeAnnotationDataType < ActiveRecord::Migration
  def self.up
    change_column :annotations, :text, :text
  end

  def self.down
    change_column :annotations, :text, :string
  end
end
