class AddEmailToInterestedPartyReport < ActiveRecord::Migration
  def self.up
    add_column :interested_party_reports, :email, :string
  end

  def self.down
    remove_column :interested_party_reports, :email
  end
end
