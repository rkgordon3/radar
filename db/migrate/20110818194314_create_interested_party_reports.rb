class CreateInterestedPartyReports < ActiveRecord::Migration
  def self.up
    create_table :interested_party_reports do |t|
      t.integer :interested_party_id
      t.integer :report_id
      t.integer :times_forwarded

      t.timestamps
    end
  end

  def self.down
    drop_table :interested_party_reports
  end
end
