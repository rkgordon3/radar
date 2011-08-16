class ChangeStaffsIdToStaffIdInReport < ActiveRecord::Migration
  def self.up
  	  
  	  remove_column :reports, :staffs_id
  end

  def self.down
  end
end
