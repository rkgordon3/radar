class RemovePasswordSaltFromStaffs < ActiveRecord::Migration
  def up
		change_column :staffs, :password_salt, :string, :null => true
	end
	
	def down
		change_column :staffs, :password_salt, :string, :null => false
	end
end