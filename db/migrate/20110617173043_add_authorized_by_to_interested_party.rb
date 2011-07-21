class AddAuthorizedByToInterestedParty < ActiveRecord::Migration
  def self.up
    add_column :interested_parties, :authorized_by, :string
  end

  def self.down
    remove_column :interested_parties, :authorized_by
  end
end
