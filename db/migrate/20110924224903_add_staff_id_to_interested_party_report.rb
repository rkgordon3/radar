class AddStaffIdToInterestedPartyReport < ActiveRecord::Migration
  def self.up
    add_column :interested_party_reports, :staff_id, :integer
  end

  def self.down
    remove_column :interested_party_reports, :staff_id
  end
end
