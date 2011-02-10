class AddTypeToParticipant < ActiveRecord::Migration
  def self.up
  	  change_table :participants do |t|
  	  	  t.string :type
  	  end
  end

  def self.down
  end
end
