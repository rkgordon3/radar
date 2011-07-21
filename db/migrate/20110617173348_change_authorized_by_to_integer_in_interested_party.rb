class ChangeAuthorizedByToIntegerInInterestedParty < ActiveRecord::Migration
  def self.up
	change_table :interested_parties do |t|
  	  t.remove   :authorized_by
  	  t.integer   :authorized_by_id
	end
  end

  def self.down
  end
end
