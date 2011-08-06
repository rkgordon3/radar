class Ability
  include CanCan::Ability

  def initialize(staff)
    alias_action :start_shift, :end_shift, :start_round, :end_round, :to => :do

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
      can :manage, [Import, IncidentReport, MaintenanceReport, Note, Task, TaskAssignment, Staff, Student, Shift, Round, Area, Building]
      cannot :read, Report, :submitted => false
      can :read, Report, :staff_id => staff.id
      cannot :do, [Shift, Round]
      cannot :update_organization, Staff
      cannot :destroy, IncidentReport

    elsif access_level_symbol == :administrator
      cannot :destroy, :all
      can :destroy, [Staff, Task]
      cannot [:update, :show, :destroy], Staff, :access_level => {:display_name => ["System Administrator","Administrator"]}
      
    elsif access_level_symbol == :administrative_assistant
      cannot [:update, :show, :destroy], Staff, :access_level => {:display_name => "Administrative Assistant"}
    
    elsif access_level_symbol == :hall_director
      cannot [:update, :show, :destroy], Staff, :access_level => {:display_name => "Hall Director"}
      cannot :update, [IncidentReport, MaintenanceReport], :submitted => true
      cannot [:update, :create, :destroy], [Building, Area]
      cannot :manage, Import
    
    elsif access_level_symbol == :resident_assistant
      cannot [:read, :update, :destroy], [Staff, Report]
      can [:read, :update], Report, :staff_id => staff.id
      cannot :update, Report, :submitted => true
      
      can :do, [Shift, Round]
      can :index, Staff
      cannot [:create, :update_area], Staff
      cannot :view_contact_info, Student
      cannot :index, Shift
      cannot :manage, Task
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
