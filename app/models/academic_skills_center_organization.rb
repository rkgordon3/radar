class AcademicSkillsCenterOrganization < Organization 
  MY_REPORTS = [TutorReport, TutorByAppointmentReport]
  MY_REPORT_TYPES = MY_REPORTS.each.collect { |r| r.name }
  
  def default_contact_reason
    RelationshipToReport.where(:description => "Other", :organization_id => self.id).first
  end
  private
  
  def administrator_base reports, ability, staff
    ability.can [ :view_contact_info, :view_contact_history], Participant
	reports.each { |r| ability.can [:show,:index, :pdf, :forward, :update], Report, { :type => r.name } } 
	# required to show contact history
	ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
	ability.can :manage, RelationshipToReport, { :organization_id => self.id }
	ability.can [:register,:assign], Organization, { :id => self.id }
  end
  
  def system_administrator(ability, staff)
	ability_base MY_REPORTS, ability, staff
	administrator_base MY_REPORTS, ability, staff
	
  	ability.can :assign, AccessLevel, :name => ["Administrator", "AdministrativeAssistant", "Supervisor", "Staff"]

    # Limit access to those reports in this organization
    ability.can [:create, :read, :show, :index, :update, :search, :pdf], Report, {:type => MY_REPORT_TYPES} 

    ability.can [:show], Staff
    ability.can [:create, :update, :destroy], Staff,
    {
      :organizations => { :id => self.id },
      :access_levels  => {:display_name => ["Administrator", "Administrative Assistant", "Supervisor", "Staff"]}
    }
  end
    
  def supervisor(ability, staff)
    puts ( "*********Apply abilities to asc supervisor ")
	ability_base MY_REPORTS, ability, staff
	
	ability.can [:view_contact_info, :view_contact_history], Participant
	# Staff
    ability.can [:update, :show], Staff, { :access_levels => {:name =>  "Staff" }, :organizations => { :id => self.id } }
    
    MY_REPORT_TYPES.each { |r| ability.can [:show, :index, :pdf, :forward], Report, { :type => r } }  

    ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
  end
  
  def staff(ability, staff)
    puts ( "*********Apply abilities to asc staff ")
    ability_base MY_REPORTS, ability, staff
	
    ability.can [:show], TutorReport, { :staff_id => staff.id  }
  end
  
  def ability_base reports, ability, staff
    ability.can [:index, :search, :show], Participant
	# Can index staff within my organization
    ability.can :index, Staff, :organizations => { :id => self.id }
    ability.can [:update, :show], Staff, :id => staff.id 

	# Establish authority to select reports from menu
    reports.each do |r| 
		ability.can [:select], ReportType, { :name => r.name } 
	end
	
	# Search
	ability.can :search, Report
	
	ability.can :create, reports
	ability.can :modify_live, Report
				
	reports.each do |r| 
		ability.can :index, Report, { :type=> r.name, :staff_id => staff.id } 
	end

	ability.can [:update], reports, { :staff_id => staff.id, :submitted  => false } 

  end
end