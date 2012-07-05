class ResidenceLifeOrganization < Organization
  attr_reader :preferred_report_type
  
  MY_REPORTS = [IncidentReport, MaintenanceReport, Note]
  MY_REPORT_TYPES = MY_REPORTS.each.collect { |r| r.name }
  
  def default_contact_reason
    RelationshipToReport.where(:description => "FYI", :organization_id => self.id).first
  end
  
  def preferred_report_type
	"IncidentReport"
  end
  
  def preferred_menu_bar
	self.type + "/home"
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
	
    # Can view all staff
    ability.can [:show], Staff
    ability.can :assign, AccessLevel, :name => ["Administrator", "AdministrativeAssistant", "Supervisor", "Staff", "CampusSafety", "CampusSafetyTemp", "HallDirector", "ResidentAssistant"]
	
    # These access_levels are being deprecated. Staff => Resident Assistant, Supervisor => HD
    ability.can [:create, :update, :destroy, :update_area], Staff,
    {
      :organizations => { :id => self.id },
      :access_levels=> {:name => ["HallDirector", "ResidentAssistant" ]}
    }
    # These access levels are organization-generic.
    ability.can [:create, :update, :destroy, :update_area], Staff,
      {
      :organizations => { :id => self.id },
      :access_levels => {:name => ["Administrator", "AdministrativeAssistant", "Supervisor", "Staff", "CampusSafety", "CampusSafetyTemp"]}
    }
	
	ability.can [:list_RA_duty_logs, :list_HD_call_logs], Shift
    ability.can [:shift_log, :read], Shift, :staff => {:access_levels => {:display_name => ["Resident Assistant", "Hall Director"]}}
    ability.can [:read, :create, :shift_log, :update, :update_shift_times], Shift, :staff_id => staff.id
	
    ability.can :manage, [Task, Building, Area]
    ability.can :manage, NotificationPreference
	ability.can :update_preferences, Staff, :staff_id => staff.id
    ability.can :assign, Area
  end
  
  def administrator(ability, staff)
	ability_base MY_REPORTS, ability, staff
	administrator_base MY_REPORTS, ability, staff
		
    ability.can :assign, AccessLevel, :name => ["Administrator", "AdministrativeAssistant", "Supervisor", "Staff", "CampusSafety", "CampusSafetyTemp" ]

	# Staff
    # Can c/u/d HD and RA in my org. These levels to be deprecated.
    ability.can [:create, :update, :destroy], Staff,
      {
      :organizations => { :id => self.id },
      :access_levels => {:name => ["HallDirector", "ResidentAssistant"]}
    }
    # Can c/u/d admin asst, supervisor and staff for my org.
    ability.can [:create, :update, :destroy], Staff,
      {
      :organizations => { :id => self.id },
      :access_levels => {:name => ["AdministrativeAssistant", "Supervisor", "Staff", "CampusSafetyTemp", "CampusSafety"]}
    }
	
    # Notification Preferences
	# Both of these abilities are needs to update a user's notification preferences.
	# NOTE: This is not  quite right, to have to have ability to two controllers for a single task!
	ability.can :update_preferences, Staff, :staff_id => staff.id
	ability.can :manage, NotificationPreference, :staff_id => staff.id
	
    ability.can :manage, Task
    ability.can :assign, Area
  end
  
  def administrative_assistant(ability, staff)
	ability_base MY_REPORTS, ability, staff
    ability.can [ :view_contact_info, :view_contact_history], Participant

    ability.can [:pdf, :show, :forward], Report, { :type => MY_REPORT_TYPES }
	
	ability.can [:update, :show], Staff, { :access_levels => {:name => [ "ResidentAssistant", "Staff" ]} , :organizations => { :id => self.id } }

    ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
	# Notification Preferences
	# Both of these abilities are needs to update a user's notification preferences.
	# NOTE: This is not  quite right, to have to have ability to two controllers for a single task!
	ability.can :update_preferences, Staff, :staff_id => staff.id
	ability.can :manage, NotificationPreference, :staff_id => staff.id

    ability.can :manage, Task
  end
  
  def campus_safety(ability, staff)
    ability_base [IncidentReport, Note], ability, staff

	ability.can [ :view_contact_info, :view_contact_history], Participant
    ability.can [:pdf, :show, :read], IncidentReport
	# required to show contact history
	ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
	# Notification Preferences
	# Both of these abilities are needs to update a user's notification preferences.
	# NOTE: This is not  quite right, to have to have ability to two controllers for a single task!
	ability.can :update_preferences, Staff, :staff_id => staff.id
	ability.can :manage, NotificationPreference, :staff_id => staff.id

  end
  
  def campus_safety_temp(ability, staff)
	ability_base [IncidentReport, Note], ability, staff
	ability.can [ :view_contact_info], Participant
    #ability.can [:pdf, :show, :read], IncidentReport
	# required to show contact history
	#ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
    
	# Notification Preferences
	# Both of these abilities are needs to update a user's notification preferences.
	# NOTE: This is not  quite right, to have to have ability to two controllers for a single task!
	ability.can :update_preferences, Staff, :staff_id => staff.id
	ability.can :manage, NotificationPreference, :staff_id => staff.id

  end
  
  def supervisor(ability, staff)
    hall_director(ability,staff)
  end
  
  def hall_director(ability, staff)
	# ability_base
	ability_base MY_REPORTS, ability, staff
	# Participant
    ability.can [:view_contact_info, :view_contact_history], Participant
	# Staff
    ability.can [:update, :show], Staff, { :access_levels => {:name => [ "ResidentAssistant", "Staff" ]} , :organizations => { :id => self.id } }
	# Notification Preferences
	# Both of these abilities are needs to update a user's notification preferences.
	# NOTE: This is not  quite right, to have to have ability to two controllers for a single task!
	ability.can :update_preferences, Staff, :staff_id => staff.id
	ability.can :manage, NotificationPreference, :staff_id => staff.id
	
    MY_REPORTS.each { |r| ability.can [:show,:index, :pdf, :forward], Report, { :type => r.name } }  
	
	# required to show contact history
	ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }

	ability.can :assign, Organization, :id => self.id
	
    ability.can [:list_RA_duty_logs, :list_HD_call_logs], Shift
    ability.can [:shift_log, :read], Shift, :staff => {:access_levels => {:display_name => "Resident Assistant"}}
    ability.can [:read, :create, :shift_log, :update, :update_shift_times], Shift, :staff_id => staff.id
	
    ability.can :update, Building


    ability.can :manage, Task
    ability.can :index, [Building, Area, Task]
	ability.can [:index, :update, :create], RelationshipToReport, { :organization_id => self.id }
    ability.can :assign, Area

  end
  
  def staff(ability, staff)
    resident_assistant(ability, staff)
  end
  
  def resident_assistant(ability, staff)
	
    ability_base MY_REPORTS, ability, staff
	
    ability.can :do, Shift, :time_out => nil
    ability.can :do, Round, :end_time => nil
    ability.can :do, TaskAssignment
    ability.can [:shift_log, :read], Shift, { :staff_id => staff.id }

  end
  

  
  # ability_base Abilities
  #	 
  def ability_base(reports, ability, staff)
  
    ability.can [:index, :search, :show], Participant
	ability.can [:manage], Preference, { :staff_id => self.id }
	ability.can :index, Staff, :organizations => { :id => self.id }
    ability.can [:update, :show], Staff, :id => staff.id

	# Establish authority to select reports from menu
    reports.each do |r| 
		ability.can [:select, :index], ReportType, { :name => r.name } 
	end
	
	ability.can :search, Report
	
	ability.can [:create], reports
	ability.can :modify_live, Report
	reports.each do |r| 
		ability.can :index, Report, { :type=> r.name, :staff_id => staff.id } 
	end

	ability.can [:update], reports, { :staff_id => staff.id, :submitted  => false } 

    ability.can [:show], [MaintenanceReport, Note], {:staff_id => staff.id }
    ability.can [:show], IncidentReport, { :staff_id => staff.id, :submitted  => false }
  end
			
end