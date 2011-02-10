class CreateReportedInfractions < ActiveRecord::Migration
  def self.up
    create_table :reported_infractions do |t|
    	    t.references :report
    	    t.references :infraction
    	    t.references :student
     

      t.timestamps
    end
  end

  def self.down
    drop_table :reported_infractions
  end
end
