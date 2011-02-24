class AddAnnotationIdToReports < ActiveRecord::Migration
  def self.up
  	  change_table :reports do |t|
  	  	  t.references :annotation
  	  	  
  	  end
  end

  def self.down
  end
end
