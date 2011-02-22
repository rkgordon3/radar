class AddStudentIdColumnToParticipantsTable < ActiveRecord::Migration
  def self.up
  	  add_column :participants, :student_id, :string
  	  add_column :reports, :submitted, :boolean
  end

  def self.down
  end
end
