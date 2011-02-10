class ChangeSubmissionTimeToApproachTimeInReport < ActiveRecord::Migration
  def self.up
  	  change_table :reports do |t|
  	  	  t.remove :submissionTime
  	  	  t.datetime :approachTime
  	  end
  end

  def self.down
  end
end
