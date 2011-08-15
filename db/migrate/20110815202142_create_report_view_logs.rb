class CreateReportViewLogs < ActiveRecord::Migration
  def self.up
    create_table :report_view_logs do |t|
      t.integer :staff_id
      t.integer :report_id

      t.timestamps
    end
  end

  def self.down
    drop_table :report_view_logs
  end
end
