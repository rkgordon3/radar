class SetReportTypeDefaultToReport < ActiveRecord::Migration
  def up
     change_column_default :reports, :type, "Report"
  end

  def down
  end
end
