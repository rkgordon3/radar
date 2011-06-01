class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.string :display_name
      t.string :abbreviation

      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
