class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.string :first_name
      t.string :last_name
      t.string :cell_phone
      t.string :home_phone
      t.string :affiliation
      t.integer :age

      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
