class AddIndexPositionEditPositionShowPositionSearchPositionToReportFields < ActiveRecord::Migration
  def self.up
    add_column :report_fields, :edit_position, :integer
    add_column :report_fields, :index_position, :integer
    add_column :report_fields, :search_position, :integer
    add_column :report_fields, :show_position, :integer
  end

  def self.down
  end
end
