class AcademicSkillsCenterOrganization < Organization 
  MY_REPORTS = [TutorReport, TutorByAppointmentReport, TutorStudyTableReport, TutorDropInReport ]
  MY_REPORT_TYPES = MY_REPORTS.each.collect { |r| r.name }
  
  def default_contact_reason
    RelationshipToReport.where(:description => "Other", :organization_id => self.id).first
  end
  
  def preferred_report_type
	MY_REPORT_TYPES
  end
  
  def preferred_sort_order
	"created_at DESC"
  end
    
  private
  
  def administrator_base reports, ability, staff
    ability.can [ :view_contact_info, :view_contact_history, :show], Participant
	reports.each { |r| ability.can [:show,:index, :pdf, :forward, :update], Report, { :type => r.name } } 
	# required to show contact history
	ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
	ability.can :manage, RelationshipToReport, { :organization_id => self.id }
	ability.can [:register,:assign], Organization, { :id => self.id }
  end
  
  def system_administrator(ability, staff)
	ability_base MY_REPORTS, ability, staff
	administrator_base MY_REPORTS, ability, staff
	
  	ability.can :assign, AccessLevel, :name => ["AdministrativeAssistant", "Supervisor", "Staff"]

    # Limit access to those reports in this organization
    ability.can [:create, :read, :show, :index, :update, :search, :pdf], Report, {:type => MY_REPORT_TYPES} 

    ability.can [:show], Staff
    ability.can [:create, :update, :destroy], Staff,
    {
      :organizations => { :id => self.id },
      :access_levels  => {:display_name => ["Administrator", "Administrative Assistant", "Supervisor", "Staff"]}
    }
  end
  
  def administrative_assistant(ability, staff)
	ability_base MY_REPORTS, ability, staff
	
    ability.can [ :view_contact_info, :view_contact_history, :show], Participant

    #ability.can [:pdf, :show, :forward], Report, { :type => MY_REPORT_TYPES }
    MY_REPORT_TYPES.each { |r| ability.can [:show, :index, :pdf, :forward], Report, { :type => r } }  
	
	ability.can [:update, :show], Staff, { :access_levels => {:name => [ "Supervisor", "Staff" ]} , :organizations => { :id => self.id } }
	ability.can :assign, Organization, :id => self.id

    ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
  end
    
  def supervisor(ability, staff)
	ability_base MY_REPORTS, ability, staff
	
	ability.can [:view_contact_info, :view_contact_history, :show], Participant
	# Staff
    ability.can [:update, :show], Staff, { :access_levels => {:name =>  "Staff" }, :organizations => { :id => self.id } }
    ability.can :assign, Organization, :id => self.id

    MY_REPORT_TYPES.each { |r| ability.can [:show, :index, :pdf, :forward], Report, { :type => r } }  

    ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
  end
  
  def staff(ability, staff)
    ability_base MY_REPORTS, ability, staff
	
    ability.can [:show], TutorReport, { :staff_id => staff.id  }
  end
  
  def ability_base reports, ability, staff
    ability.can [:index, :search], Participant
	ability.can [:manage], Preference, { :staff_id => self.id }
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