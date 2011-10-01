class Ability
  include CanCan::Ability

  def initialize(staff)
    alias_action :start_shift, :end_shift, :update_todo, :start_round, :end_round, :update, :to => :do
    alias_action :call_log, :duty_log, :to => :shift_log
    alias_action :forward_as_mail => :forward

    staff ||= Staff.new

    if staff.organization? :residence_life
      #set all actions for residence life
      
      if staff.access_level? :system_administrator
        trim_residence_life_privileges_to(:system_administrator, staff)
      elsif staff.access_level? :administrator
        trim_residence_life_privileges_to(:system_administrator, staff)
        trim_residence_life_privileges_to(:administrator, staff)
      elsif staff.access_level? :administrative_assistant
        trim_residence_life_privileges_to(:system_administrator, staff)
        trim_residence_life_privileges_to(:administrator, staff)
        trim_residence_life_privileges_to(:administrative_assistant, staff)
      elsif staff.access_level? :hall_director
        trim_residence_life_privileges_to(:system_administrator, staff)
        trim_residence_life_privileges_to(:administrator, staff)
        trim_residence_life_privileges_to(:administrative_assistant, staff)
        trim_residence_life_privileges_to(:hall_director, staff)
      elsif staff.access_level? :resident_assistant
        trim_residence_life_privileges_to(:system_administrator, staff)
        trim_residence_life_privileges_to(:administrator, staff)
        trim_residence_life_privileges_to(:administrative_assistant, staff)
        trim_residence_life_privileges_to(:hall_director, staff)
        trim_residence_life_privileges_to(:resident_assistant, staff)
      elsif staff.access_level? :campus_safety
        trim_residence_life_privileges_to(:system_administrator, staff)
        trim_residence_life_privileges_to(:administrator, staff)
        trim_residence_life_privileges_to(:administrative_assistant, staff)
        trim_residence_life_privileges_to(:hall_director, staff)
        trim_residence_life_privileges_to(:resident_assistant, staff)
        trim_residence_life_privileges_to(:campus_safety, staff)
      end

      #these apply to all levels of ResLife
      can [:update, :show], Staff, :id => staff.id
      cannot [:destroy,:update_access_level,:update_organization], Staff, :id => staff.id
      
    elsif staff.organization? :academic_skills_center
      # trim or build privileges for each Academic Skills access_level here
      if staff.access_level? :system_administrator
        trim_academic_skills_center_privileges_to(:system_administrator, staff)
      end
    else
      # this user does not belong to an organization and is therefore not logged in
      can :landingpage, :home
    end
  end

  # removes specific residence life privileges for the specified access level
  def trim_residence_life_privileges_to(access_level_symbol, staff)
    if access_level_symbol == :system_administrator
      can :manage, :all
      cannot [:index, :update, :create], :all
      cannot [:read, :update, :destroy, :create], Report
      can :index, Report
      can :manage, [RelationshipToReport, Import, IncidentReport, MaintenanceReport, Note, Task, TaskAssignment, Staff, Participant, Shift, Round, Area, Building, NotificationPreference]
      cannot :read, Report, :submitted => false
      can :read, Report, :staff_id => staff.id
      cannot :do, [Shift, Round]
      cannot :create, Shift
      cannot [:update_organization, :destroy], Staff
      cannot :destroy, [IncidentReport, Task, RelationshipToReport]

    elsif access_level_symbol == :administrator
      cannot [:update, :show, :destroy], Staff, :access_level => {:display_name => ["System Administrator","Administrator"]}
      cannot :manage, Import
	  can :manage, RelationshipToReport
	  cannot :destroy, RelationshipToReport
      
    elsif access_level_symbol == :administrative_assistant
      cannot [:update, :show, :destroy], Staff, :access_level => {:display_name => "Administrative Assistant"}
    
    elsif access_level_symbol == :hall_director
      cannot :destroy, Staff
      cannot [:update, :show], Staff, :access_level => {:display_name => "Hall Director"}
      cannot :update, [IncidentReport, MaintenanceReport], :submitted => true
      cannot [:update, :create, :destroy], [Building, Area]

      cannot :manage, Shift

      can [:list_RA_duty_logs], Shift
      can [:shift_log, :read], Shift, :staff => {:access_level => {:display_name => "Resident Assistant"}}
      can [:read, :create, :shift_log, :update, :update_shift_times], Shift, :staff_id => staff.id
    
    elsif access_level_symbol == :resident_assistant
      cannot :destroy, :all
      cannot [:read, :update, :destroy], [Staff, Report]
      can [:read, :update], Report, :staff_id => staff.id
      cannot :update, [IncidentReport, MaintenanceReport], :submitted => true
      cannot :show, IncidentReport, :submitted => true
      cannot [:print, :forward], Report

      cannot :manage, Shift
      can :do, Shift, :time_out => nil
      can :do, Round, :end_time => nil
      can [:shift_log, :read], Shift, :staff_id => staff.id

      can :index, Staff
      cannot [:create, :update_area], Staff
      cannot :view_contact_info, Participant
      cannot :manage, Task
      cannot :manage, NotificationPreference

    elsif access_level_symbol == :campus_safety
      can :read, Report
      cannot :manage, [MaintenanceReport, Note, Shift, Round, TaskAssignment, Building, Area]

    end
  end
  
  # removes specific academic skills center privileges for the specified access level
  def trim_academic_skills_center_privileges_to(access_level_symbol, staff)
    if access_level_symbol == :system_administrator
      can :manage, :all
      cannot :manage, Report
      can :manage, TutorLog
      cannot :update_organization, Staff
    end
  end

end
