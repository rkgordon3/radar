class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.string :staff_id
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
