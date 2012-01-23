class ResidenceLifeOrganization < Organization
  MY_REPORTS = [IncidentReport, MaintenanceReport, Note]
  MY_REPORT_TYPES = MY_REPORTS.each.collect { |r| r.name }
  
  private

  def system_administrator(ability, staff) 
    ability.can [:index, :search, :view_contact_info, :view_contact_history, :show], Participant
    ability.can [:create, :read, :update, :search, :pdf, :show], MY_REPORTS
    ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
    # Limit access to those reports in this organization
    ability.can [:create, :read, :show, :index, :update, :search, :add_participant, :remove_participant, :create_participant_and_add_to_report, :forward], Report, :organization_id => self.id
    # Can view all staff
    ability.can [:read], Staff
    # These access_levels are being deprecated. Staff => Resident Assistant, Supervisor => HD
    ability.can [:create, :update, :destroy, :update_access_level ], Staff,
      {
      :organizations => { :id => self.id },
      :access_levels=> {:name => ["HallDirector", "ResidentAssistant", "CampusSafety" ]}
    }
    # These access levels are organization-generic.
    ability.can [:create, :update, :destroy, :update_access_level], Staff,
      {
      :organizations => { :id => self.id },
      :access_levels => {:name => ["Administrator", "Administrative Assistant", "Supervisor", "Staff"]}
    }
    ability.can :manage, [Task, Building, Area]
    ability.can :manage, NotificationPreference
    ability.can :register, Organization, :id => self.id
    ability.can :assign, AccessLevel, :name => ["Administrator", "AdministrativeAssistant", "Supervisor", "Staff", "CampusSafety", "HallDirector", "ResidentAssistant"]
    ability.can :assign, Area
    ability.can [:select], ReportType, { :name => MY_REPORT_TYPES }
  end
  
  def administrator(ability, staff)
    ability.can :assign, AccessLevel, :name => ["AdministrativeAssistant", "Supervisor", "Staff", "CampusSafety"]
  	ability.can :register, Organization, :id => self.id
    ability.can [:index, :search, :view_contact_info, :view_contact_history, :show], Participant
    ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
    ability.can [:create, :read, :update, :search, :show, :forward], MY_REPORTS
    ability.can [:add_participant, :create_participant_and_add_to_report, :remove_participant], Report, { :type => MY_REPORT_TYPES}
    ability.can [:create, :update, :read, :pdf], Report, { :type => MY_REPORT_TYPES }
    # Can view staff in my org
    ability.can :index, Staff, organizations => { :id => self.id }
    # Can c/u/d HD and RA in my org. These levels to be deprecated.
    ability.can [:create, :update, :destroy], Staff,
      {
      :organizations => { :id => self.id },
      :access_levels => {:name => ["HallDirector", "ResidentAssistant", "CampusSafety"]}
    }
    # Can c/u/d admin asst, supervisor and staff for my org.
    ability.can [:create, :update, :destroy], Staff,
      {
      :organizations => { :id => self.id },
      :access_levels => {:name => ["AdministrativeAssistant", "Supervisor", "Staff"]}
    }
    ability.can :update, NotificationPreference
    ability.can :manage, Task
    ability.can [:register, :update], Staff, :organizations => { :id => self.id }
    ability.can :assign, Area
    ability.can [:select], ReportType, { :name => MY_REPORT_TYPES }
  end
  
  def administrative_assistant(ability, staff)
    ability.can [:index, :search, :view_contact_info, :view_contact_history, :show], Participant
    ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
    ability.can [:add_participant, :create_participant_and_add_to_report, :remove_participant], Report, { :staff_id => staff.id }
    ability.can [:search] , MY_REPORTS
    ability.can [:create, :pdf, :show, :forward], Report, { :type => MY_REPORT_TYPES }
    ability.can [:read, :update], MY_REPORTS,  { :staff_id => staff.id, :submitted => false }
    ability.can :update, NotificationPreference
    ability.can :index, Staff, :organizations => { :id => self.id }
    ability.can :manage, Task
    ability.can [:select], ReportType, { :name => MY_REPORT_TYPES }
    ability.can :search, Report
  end
  
  def campus_safety(ability, staff)
    ability.can [:index, :search, :view_contact_info, :show], Participant
    ability.can [:create, :index, :search, :pdf, :show, :forward], Report, { :type => "IncidentReport" }
    ability.can [:add_participant, :create_participant_and_add_to_report, :remove_participant], Report, { :staff_id => staff.id }
    ability.can [:show], Note, {:staff_id => staff.id }
    ability.can [:show], IncidentReport, { :staff_id => staff.id, :submitted  => false }
    ability.can [ :update], IncidentReport, { :staff_id => staff.id, :submitted  => false, :type => "IncidentReport" }
    ability.can :update, NotificationPreference, :staff_id => staff.id
    ability.can :index, Staff, :organizations => { :id => self.id }
    ability.can [:update, :show], Staff, :id => staff.id

  end
  
  def supervisor(ability, staff)
    hall_director(ability,staff)
  end
  
  def hall_director(ability, staff)
    puts ("*********Apply abilities to hall director")
    ability.can [:index, :search, :view_contact_info, :view_contact_history, :show], Participant
    ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
    ability.can [:create, :pdf, :forward], Report, { :type => MY_REPORT_TYPES}
    ability.can [:add_participant, :create_participant_and_add_to_report, :remove_participant], Report, {  :submitted  => false, :staff_id => staff.id }
    ability.can [:show], [MaintenanceReport, Note], {:staff_id => staff.id }
    ability.can [:show], IncidentReport, { :staff_id => staff.id, :submitted  => false }
    ability.can [:read, :update], MY_REPORTS,  { :staff_id => staff.id, :submitted => false }
    ability.can :show, MY_REPORTS
    #ability.can [:create, :read, :update], DutyLog
    ability.can [:list_RA_duty_logs], Shift
    ability.can [:shift_log, :read], Shift, :staff => {:access_levels => {:display_name => "Resident Assistant"}}
    ability.can [:read, :create, :shift_log, :update, :update_shift_times], Shift, :staff_id => staff.id
    ability.can :update, Building
    ability.can :manage, NotificationPreference, :staff_id => staff.id
    ability.can :manage, Task
    ability.can :index, [Building, Area, Task, RelationshipToReport]
    ability.can :index, Staff, :organizations => { :id => self.id }
    ability.can [:update, :show], Staff, { :access_levels => {:name => "ResidentAssistant"}, :organizations => { :id => self.id } }
    ability.can :assign, Area
    ability.can [ :index, :search], Report, {:type => MY_REPORT_TYPES }
    ability.can [:select], ReportType, { :name => MY_REPORT_TYPES }
  end
  
  def staff(ability, staff)
    resident_assistant(ability, staff)
  end
  
  def resident_assistant(ability, staff)
    puts ( "*********Apply abilities to resident assistant")
    ability.can [:index, :search, :show], Participant
    ability.can [:search], MY_REPORTS
    ability.can [:create, :forward], Report, { :type => MY_REPORT_TYPES }
    ability.can [:add_participant, :create_participant_and_add_to_report, :remove_participant], Report, {  :submitted  => false, :staff_id => staff.id }
    ability.can [:index, :search], Report, { :staff_id => staff.id, :type => MaintenanceReport.to_s }
    ability.can [:index, :update], Report, { :staff_id => staff.id, :submitted  => false, :type => MY_REPORT_TYPES }
    # Establish authority to select reports from menu
    ability.can [:select], ReportType, { :name => MY_REPORT_TYPES }
    ability.can [:show], [MaintenanceReport, Note], {:staff_id => staff.id }
    ability.can [:show], IncidentReport, { :staff_id => staff.id, :submitted  => false }
    ability.can :do, Shift, :time_out => nil
    ability.can :do, Round, :end_time => nil
    ability.can :do, TaskAssignment
    ability.can [:shift_log, :read], Shift, { :staff_id => staff.id }
    # staff-related
    ability.can :index, Staff, :organizations => { :id => self.id }
    ability.can [:update, :show], Staff, :id => staff.id
	
  end
			
end