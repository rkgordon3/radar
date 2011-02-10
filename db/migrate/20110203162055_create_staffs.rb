class CreateStaffs < ActiveRecord::Migration
  def self.up
    create_table :staffs do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.string :password
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :staffs
  end
end
