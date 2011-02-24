class CreateAnnotationsTable < ActiveRecord::Migration
  def self.up
  	  create_table :annotations do |t|
  	  	  t.string :annotation
  	  	  t.integer :report_id
  	  	  t.timestamps
  	  end
  end

  def self.down
  end
end
