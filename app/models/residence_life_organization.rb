class ResidenceLifeOrganization < Organization
  MY_REPORTS = [IncidentReport, MaintenanceReport, Note]
  
  private

  def system_administrator(ability, staff) 
	# Limit access to those reports in this organization
    ability.can [:create, :read, :show, :index, :update, :search, :add_particpant], Report, :organization_id => self.id
	# Can view all staff 
	ability.can [:read], Staff
	ability.can :update, Staff, :id => staff.id
	# These access_levels are being deprecated. Staff => Resident Assistant, Supervisor => HD
	ability.can [:create, :update, :destroy], Staff, 
					{
						:organizations => { :id => self.id },
						:access_level => {:display_name => ["Hall Director", "Resident Assistant"]}
					}
	# These access levels are organization-generic.
	ability.can [:create, :update, :destroy], Staff, 
					{ 
						:organizations => { :id => self.id },
						:access_level => {:display_name => ["Administrator", "Administrative Assistant", "Supervisor", "Staff"]}
					}
	ability.can :manage, Task
	ability.can :manage, NotificationPreference
	ability.can :register, Organization, :id => self.id
	ability.can :assign, AccessLevel, :name => ["Administrator", "AdministrativeAssistant", "Supervisor", "Staff"]
	ability.can :assign, Area
	ability.can :search, Report
  end
  
  def administrator(ability, staff)
	ability.can :assign, AccessLevel, :name => ["AdministrativeAssistant", "Supervisor", "Staff"]
  	ability.can :register, Organization, :id => self.id
    ability.can [:index, :search], Participant
	ability.can [:create, :read, :update, :search], MY_REPORTS
	#ability.can [:create, :read, :update], DutyLog
	# Can view staff in my org
	ability.can :index, Staff, organizations => { :id => self.id }
	# Can c/u/d HD and RA in my org. These levels to be deprecated.
	ability.can [:create, :update, :destroy], Staff, 
					{
						:organizations => { :id => self.id },
						:access_level => {:display_name => ["Hall Director", "Resident Assistant"]}
					}
	# Can c/u/d admin asst, supervisor and staff for my org.
	ability.can [:create, :update, :destroy], Staff, 
					{
						:organizations => { :id => self.id },
						:access_level => {:display_name => ["Administrative Assistant", "Supervisor", "Staff"]}
					}
	ability.can :update, NotificationPreference
	ability.can :manage, Task
	ability.can [:register, :update], Staff, :organizations => { :id => self.id }	
	ability.can :assign, Area
	ability.can [:search], ReportType, { :name => ["Note", "IncidentReport", "MaintenanceReport" ] }
  end
  
  def administrative_assistant(ability, staff)
    ability.can [:index,:search], Participant
	ability.can [:add_participant], Report, { :staff_id => staff.id }
	ability.can [:create, :search] , MY_REPORTS
    ability.can [:read, :update], MY_REPORTS,  { :staff_id => staff.id, :submitted => false }
	ability.can :update, NotificationPreference
	ability.can :index, Staff, :organizations => { :id => self.id }
	ability.can :manage, Task
	ability.can [:search], ReportType, { :name => ["Note", "IncidentReport", "MaintenanceReport" ] }
	ability.can :search, Report
  end
  
  def campus_safety(ability, staff)
    ability.can [:index, :search], Participant
	ability.can [:index, :view_contact_info, :view_contact_history], Participant
    ability.can [:create, :search], IncidentReport
	ability.can [:show], Note, {:staff_id => staff.id }
	ability.can [:show], IncidentReport, { :staff_id => staff.id, :submitted  => false }
	ability.can [:index, :update], IncidentReport, { :staff_id => staff.id, :submitted  => false, :type => IncidentReport.to_s }
	ability.can :update, NotificationPreference, :staff_id => staff.id
	ability.can :index, Staff, :organizations => { :id => self.id }
	ability.can [:update, :show], Staff, :id => staff.id
	ability.can :search, Report
  end
  
  def supervisor(ability, staff)
    hall_director(ability,staff)
  end
  
  def hall_director(ability, staff)
    puts ("*********Apply abilities to hall director")
	ability.can [:index, :search, :view_contact_info, :view_contact_history], Participant
	ability.can [:create], MY_REPORTS
    ability.can [:add_participant], Report, { :staff_id => staff.id }
	ability.can [:show], [MaintenanceReport, Note], {:staff_id => staff.id }
	ability.can [:show], IncidentReport, { :staff_id => staff.id, :submitted  => false }
    ability.can [:read, :update], MY_REPORTS,  { :staff_id => staff.id, :submitted => false }
	#ability.can [:create, :read, :update], DutyLog
    ability.can [:list_RA_duty_logs], Shift
    ability.can [:shift_log, :read], Shift, :staff => {:access_level => {:display_name => "Resident Assistant"}}
    ability.can [:read, :create, :shift_log, :update, :update_shift_times], Shift, :staff_id => staff.id
    ability.can :update, Building
	ability.can :manage, NotificationPreference, :staff_id => staff.id
	ability.can :manage, Task
	ability.can :index, [Building, Area, Task, RelationshipToReport]
	ability.can :index, Staff, :organizations => { :id => self.id }
	ability.can [:update, :show], Staff, { :access_level => {:name => "ResidentAssistant"}, :organizations => { :id => self.id } }
	ability.can :assign, Area
	ability.can [ :index, :search], Report, {:type => ["Note", "IncidentReport", "MaintenanceReport" ] }
	ability.can [:search], ReportType, { :name => ["Note", "IncidentReport", "MaintenanceReport" ] }
  end
  
  def staff(ability, staff)
    resident_assistant(ability, staff)
  end
  
  def resident_assistant(ability, staff)
    puts ( "*********Apply abilities to resident assistant")
    ability.can [:index, :search], Participant
	ability.can [:create, :search], MY_REPORTS
    ability.can [:add_participant], Report, { :staff_id => staff.id }
	ability.can [:show], [MaintenanceReport, Note], {:staff_id => staff.id }
	ability.can [:show], IncidentReport, { :staff_id => staff.id, :submitted  => false }
	ability.can :do, Shift, :time_out => nil
    ability.can :do, Round, :end_time => nil
	ability.can :do, TaskAssignment
    ability.can [:shift_log, :read], Shift, { :staff_id => staff.id }
	ability.can :index, Staff, :organizations => { :id => self.id }
	ability.can [:update, :show], Staff, :id => staff.id
	ability.can [:index], Report, { :staff_id => staff.id, :type=> Note.to_s }
	ability.can [:index, :search], Report, { :staff_id => staff.id, :type => MaintenanceReport.to_s }
	ability.can [:index, :update], Report, { :staff_id => staff.id, :submitted  => false, :type => IncidentReport.to_s }
	ability.can [:search], ReportType, { :name => ["Note", "IncidentReport", "MaintenanceReport" ] }
  end
			
end