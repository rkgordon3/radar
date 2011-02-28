class RemoveAnnotationFromAnnotations < ActiveRecord::Migration
  def self.up
  	  remove_column :annotations, :annotation
  end

  def self.down
  end
end
