class AcademicSkillsCenterOrganization < Organization

  
  private
  
  def system_administrator(ability, staff)
  	ability.can :assign, AccessLevel, :name => ["Administrator", "AdministrativeAssistant", "Supervisor", "Staff"]
    ability.can [:index, :search], Participant
	ability.can :search, Report
	# Can register users in this organization
	ability.can :register, Organization, :id => self.id	  
	# Limit access to those reports in this organization
    ability.can [:create, :read, :update, :search, :add_particpant], TutorReport, :organization_id => self.id
	ability.can [:read], Staff
	ability.can :update, Staff, :id => staff.id
	ability.can [:create, :update, :destroy], Staff, 
                 	{ 
					  :organizations => { :id => self.id },
					  :access_level => {:display_name => ["Administrator", "Administrative Assistant", "Supervisor", "Staff"]}
					} 
  end
    
  def supervisor(ability, staff)
	ability.can :search, Report
	ability.can [:index, :search], Participant
	ability.can [:index], Report, { :staff_id => staff.id}
	ability.can [ :create], TutorReport
	ability.can [:search, :read, :create, :update, :add_participant], TutorReport, :staff_id => staff.id 
	  
	# Can index staff within my organization
    ability.can :index, Staff, :organizations => { :id => self.id }
	ability.can [:update, :show], Staff, :id => staff.id
  end
  
  def staff(ability, staff)
    ability.can :search, Report
	ability.can [:index, :search], Participant

	ability.can [:search, :read, :create, :add_participant], TutorReport, :staff_id => staff.id 
	ability.can [:index, :update], Report, { :staff_id => staff.id,  :type => TutorReport.to_s }
	# Can index staff within my organization
    ability.can :index, Staff, :organizations => { :id => self.id }
	ability.can [:update, :show], Staff, :id => staff.id
  end
end