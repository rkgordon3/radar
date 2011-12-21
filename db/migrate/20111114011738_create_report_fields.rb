class CreateReportFields < ActiveRecord::Migration
  def self.up
    create_table :report_fields do |t|
      t.integer :report_type_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :report_fields
  end
end
