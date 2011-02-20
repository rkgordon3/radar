class ChangeStaffsIdToStaffIdInReport < ActiveRecord::Migration
  def self.up
  	  change_table :reports do |t|
  	  	  t.references :staff
  	  	  
  	  end
  	  remove_column :reports, :staffs_id
  end

  def self.down
  end
end
