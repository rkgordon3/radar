class AddTextToAnnotation < ActiveRecord::Migration
  def self.up
  	  add_column :annotations, :text, :string
  end

  def self.down
  end
end
