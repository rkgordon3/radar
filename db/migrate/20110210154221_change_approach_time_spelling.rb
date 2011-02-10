class ChangeApproachTimeSpelling < ActiveRecord::Migration
  def self.up
  	  change_table :reports do |t|
  	  	  t.remove :approachTime
  	  	  t.datetime :approach_time
  	  end
  end

  def self.down
  end
end
