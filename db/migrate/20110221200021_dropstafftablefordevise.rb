class Dropstafftablefordevise < ActiveRecord::Migration
  def self.up
  drop_table :staffs
  end

  def self.down
  end
end
