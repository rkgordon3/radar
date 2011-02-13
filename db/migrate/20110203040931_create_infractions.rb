class CreateInfractions < ActiveRecord::Migration
  def self.up
    create_table :infractions do |t|
    	    t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :infractions
  end
end
