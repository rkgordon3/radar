class AcademicSkillsCenterOrganization < Organization

 def apply_privileges(ability, staff)
    ability.can :manage, TutorReport
	ability.can :manage, Participant
    #if staff.access_level? :system_administrator
    #    trim_privileges_to(ability, :system_administrator,staff)
    #end
  end
  
  private
    # removes specific academic skills center privileges for the specified access level
  def trim_privileges_to(ability, access_level_symbol, staff)
    if access_level_symbol == :system_administrator
      ability.can :manage, :all
	  
	  ability.can :register, Organization
	  #ability.can :register, Organization, :id => self.id
      ability.can :manage, TutorReport
      ability.cannot :update_organization, Staff
      ability.can :manage, [ Participant]
    end
  end
end