class CreateInterestedParties < ActiveRecord::Migration
  def self.up
    create_table :interested_parties do |t|
      t.string :email
      t.integer :report_id

      t.timestamps
    end
  end

  def self.down
    drop_table :interested_parties
  end
end
