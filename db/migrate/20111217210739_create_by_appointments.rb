class CreateByAppointments < ActiveRecord::Migration
  def self.up
    create_table :by_appointments do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :by_appointments
  end
end
