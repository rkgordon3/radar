class ResidenceLifeOrganization < Organization
  MY_REPORTS = [IncidentReport, MaintenanceReport, Note]

  def apply_privileges(ability, staff) 
      ability.cannot :manage, :all
	  
      self.send(staff.access_level.name.tableize.singularize, ability, staff)
=begin  
      if staff.access_level? :system_administrator
        trim_privileges_to(ability, :system_administrator, staff)
      elsif staff.access_level? :administrator
        trim_privileges_to(ability, :system_administrator, staff)
        trim_privileges_to(ability, :administrator, staff)
      elsif staff.access_level? :administrative_assistant
        trim_privileges_to(ability, :system_administrator, staff)
        trim_privileges_to(ability, :administrator, staff)
        trim_privileges_to(ability, :administrative_assistant, staff)
      elsif staff.access_level? :hall_director
        trim_privileges_to(ability, :system_administrator, staff)
        trim_privileges_to(ability, :administrator, staff)
        trim_privileges_to(ability, :administrative_assistant, staff)
        trim_privileges_to(ability, :hall_director, staff)
      elsif staff.access_level? :resident_assistant
        trim_privileges_to(ability, :system_administrator, staff)
        trim_privileges_to(ability, :administrator, staff)
        trim_privileges_to(ability, :administrative_assistant, staff)
        trim_privileges_to(ability, :hall_director, staff)
        trim_privileges_to(ability, :resident_assistant, staff)
      elsif staff.access_level? :campus_safety
        trim_privileges_to(ability, :system_administrator, staff)
        trim_privileges_to(ability, :administrator, staff)
        trim_privileges_to(ability, :administrative_assistant, staff)
        trim_privileges_to(ability, :hall_director, staff)
        trim_privileges_to(ability, :resident_assistant, staff)
        trim_privileges_to(ability, :campus_safety, staff)
      end
=end

      #these apply to all levels of ResLife
      ability.can [:update, :show], Staff, :id => staff.id
      ability.cannot [:destroy,:update_access_level,:update_organization], Staff, :id => staff.id
  end
  
  private 
    # removes specific residence life privileges for the specified access level
  def trim_privileges_to(ability, access_level_symbol, staff)
    if access_level_symbol == :system_administrator
      ability.can :manage, :all
	  ability.cannot :register, :all
	  ability.can :register, Organization, :id => self.id
      ability.cannot [ :index, :update, :create], :all
      ability.cannot [:read, :update, :destroy, :create], Report
      ability.can :index, Report
      ability.can :manage, [ RelationshipToReport, Import, IncidentReport, MaintenanceReport, Note, Task, TaskAssignment, Participant, Shift, Round, Area, Building, NotificationPreference]
      ability.can :manage, Staff, :organizations => { :id => self.id }
	  ability.cannot :read, Report, :submitted => false
      ability.can :read, Report, :staff_id => staff.id
      ability.cannot :do, [Shift, Round]
      ability.cannot :create, Shift
      ability.cannot [:update_organization, :destroy], Staff
      ability.cannot :destroy, [IncidentReport, Task, RelationshipToReport, Building]

    elsif access_level_symbol == :administrator
      ability.cannot [:update, :show, :destroy], Staff, :access_level => {:display_name => ["System Administrator","Administrator"]}
      ability.cannot :manage, Import
      ability.cannot [:update, :create, :destroy], Building
      
    elsif access_level_symbol == :administrative_assistant
      ability.cannot [:update, :show, :destroy], Staff, :access_level => {:display_name => "Administrative Assistant"}
    
    elsif access_level_symbol == :hall_director
      ability.cannot :destroy, Staff
      ability.cannot [:update, :show], Staff, :access_level => {:display_name => "Hall Director"}
      ability.cannot :update, [IncidentReport, MaintenanceReport], :submitted => true
      ability.cannot [:update, :create, :destroy], Area

      ability.cannot :manage, Shift

      ability.can [:list_RA_duty_logs], Shift
      ability.can [:shift_log, :read], Shift, :staff => {:access_level => {:display_name => "Resident Assistant"}}
      ability.can [:read, :create, :shift_log, :update, :update_shift_times], Shift, :staff_id => staff.id
      ability.can :update, Building

    elsif access_level_symbol == :resident_assistant
      ability.cannot :destroy, :all
      ability.cannot [:read, :update, :destroy], [Staff, Report]
      ability.can [:read, :update], Report,  { :staff_id => staff.id }
      ability.cannot :update, [IncidentReport, MaintenanceReport], :submitted => true
      ability.cannot :show, IncidentReport, :submitted => true
      ability.cannot [:pdf, :print, :forward], Report

      ability.cannot :manage, [Shift, RelationshipToReport, Task, NotificationPreference, Building, Area]
      ability.can :do, Shift, :time_out => nil
      ability.can :do, Round, :end_time => nil
      ability.can [:shift_log, :read], Shift, { :staff_id => staff.id }

      ability.can :index, Staff
      ability.cannot [:create, :update_area], Staff
      ability.cannot :view_contact_info, Participant
	  ability.cannot :view_contact_history, Participant

    elsif access_level_symbol == :campus_safety
      ability.can :read, Report
	  ability.can :manage, NotificationPreference
      ability.cannot :manage, [MaintenanceReport, Note, Shift, Round, TaskAssignment]

    end
  end
  
  def administrator(ability, staff)
    ability.can :index, Participant
	ability.can [:create, :read, :update], MY_REPORTS
	ability.can [:create, :read, :update], DutyLog
	ability.can :update, NotificationPreference
	ability.can :manage, Task
	ability.can [:register, :update], Staff, :organizations => { :id => self.id }
	ability.can :index, Staff
  end
  
  def administrative_assistant(ability, staff)
    ability.can :index, Participant
	ability.can :create , MY_REPORTS
    ability.can [:read, :update], MY_REPORTS,  { :staff_id => staff.id, :submitted => false }
	ability.can :update, NotificationPreference
	ability.can :index, Staff
	ability.can :manage, Task
  end
  
  def campus_safety(ability, staff)
    ability.can :index, Participant
    ability.can [:create, :read], IncidentReport
	ability.can :update, NotificationPreference
	ability.can :index, Staff
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
	ability.can :index, Staff
	ability.can [:index], Report, { :staff_id => staff.id, :type=> Note.to_s }
	ability.can [:index, :search], Report, { :staff_id => staff.id, :type => MaintenanceReport.to_s }
	ability.can [:index, :update], Report, { :staff_id => staff.id, :submitted  => false, :type => IncidentReport.to_s }
  end
  
  def hall_director(ability, staff)
    puts ("*********Apply abilities to hall director")
	ability.can :index, Participant
	ability.can :create , MY_REPORTS
    ability.can [:read, :update], MY_REPORTS,  { :staff_id => staff.id, :submitted => false }
    ability.can [:list_RA_duty_logs], Shift
    ability.can [:shift_log, :read], Shift, :staff => {:access_level => {:display_name => "Resident Assistant"}}
    ability.can [:read, :create, :shift_log, :update, :update_shift_times], Shift, :staff_id => staff.id
    ability.can :update, Building
	ability.can :manage, NotificationPreference
	ability.can [:index, :view_contact_info, :view_contact_history], Participant
	ability.can :manage, Task
  end
			
end