class AddIncidentReportTable < ActiveRecord::Migration
  def self.up
  	  create_table :IncidentReport do |t|
    	    t.string :detail
			
    	  t.timestamps
  end
  end

  def self.down
  end
end
