class CreateTableReportFields < ActiveRecord::Migration
  def self.up
      create_table :report_fields do |t|
          t.integer  :report_type_id
          t.string  :field
      end
  end

  def self.down
  end
end
