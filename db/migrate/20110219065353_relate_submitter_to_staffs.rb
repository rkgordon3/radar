class RelateSubmitterToStaffs < ActiveRecord::Migration
  def self.up
  	  change_table :reports do |t|
  	  	  t.references :staff
  	  end
  end

  def self.down
  end
end
