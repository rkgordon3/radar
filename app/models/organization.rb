class Organization < ActiveRecord::Base
  include CanCan::Ability
  attr_accessible :name,:abbreviation,:display_name  
  has_many :staff_organizations
  
  def apply_privileges(ability, staff) 
    ability.cannot :manage, :all
    self.send(staff.role_in(self), ability, staff)
  end
  
  def == other
    self.class.name == other.class.name
  end
end
