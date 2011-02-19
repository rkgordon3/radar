class DeleteBuildingFromParticipants < ActiveRecord::Migration
  def self.up
  	  remove_column :participants, :building
    end

  def self.down
  end
end
