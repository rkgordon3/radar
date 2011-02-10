class AddParticipantReferenceToReportedInfraction < ActiveRecord::Migration
  def self.up
  	  change_table :reported_infractions do |t|
  	  t.remove   :student_id
  	  t.integer   :participant_id
  end
  end

  def self.down
  	  raise IrreversibleMigration
  end
end
