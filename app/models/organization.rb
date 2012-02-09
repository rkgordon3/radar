class Organization < ActiveRecord::Base
  include CanCan::Ability
  attr_accessible :name,:abbreviation,:display_name  
  has_and_belongs_to_many :staffs, :join_table => :staff_organizations
  
  def apply_privileges(ability, staff) 
  
	begin
		
		self.send(staff.role_in(self).name.tableize.singularize, ability, staff)
	rescue Exception => e
	    puts e.backtrace.join("\n")
		puts "No role for #{staff.email} in #{self.display_name}"
	end
  end
  
  def == other
    self.class.name == other.class.name
  end
end
