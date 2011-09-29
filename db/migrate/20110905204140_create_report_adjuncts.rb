class CreateReportAdjuncts < ActiveRecord::Migration
  def self.up
    create_table :report_adjuncts do |t|
      t.integer :report_id
      t.integer :staff_id

      t.timestamps
    end
  end

  def self.down
    drop_table :report_adjuncts
  end
end
