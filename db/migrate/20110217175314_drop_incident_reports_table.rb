class DropIncidentReportsTable < ActiveRecord::Migration
  def self.up
  	  drop_table "incident_reports"
  end

  def self.down
  end
end
