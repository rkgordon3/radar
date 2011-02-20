class DropAnnotationsTable < ActiveRecord::Migration
  def self.up
  	  drop_table "annotations"
  end

  def self.down
  end
end
