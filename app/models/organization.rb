class Organization < ActiveRecord::Base
  include CanCan::Ability
  attr_accessible :name,:abbreviation,:display_name  
  
  def apply_privileges(ability, staff)
     # subclass must define
  end
end
