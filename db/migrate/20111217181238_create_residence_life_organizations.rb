class CreateResidenceLifeOrganizations < ActiveRecord::Migration
  def self.up
    create_table :residence_life_organizations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :residence_life_organizations
  end
end
