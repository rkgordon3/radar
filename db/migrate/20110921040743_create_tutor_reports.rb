class CreateTutorReports < ActiveRecord::Migration
  def self.up
    create_table :tutor_reports do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :tutor_reports
  end
end
