class FixAnnotationReportRelationship < ActiveRecord::Migration
  def self.up
  	  remove_column :reports, :annotation_id
  
  	  change_table :reports do |t|
  	  	  t.references :annotation
  	  end
  end

  def self.down
  end
end
