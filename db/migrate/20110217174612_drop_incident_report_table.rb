class DropIncidentReportTable < ActiveRecord::Migration
  def self.up
  	  drop_table "IncidentReport"
  end

  def self.down
  end
end
