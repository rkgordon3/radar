class AddPhotoFkToParticipant < ActiveRecord::Migration
  def self.up
  		  change_table :participants do |t|
  		  t.references :photo
  	  end
  end

  def self.down
  end
end
