class Ability
  include CanCan::Ability

  def initialize(staff)
    staff ||= Staff.new

    if staff.organization? :residence_life
      #set all actions for residence life
      can :manage, :all
      if staff.access_level? :system_administrator
        cannot :update_organization, Staff

      elsif staff.access_level? :administrator
        trim_residence_life_privileges_to(:administrator, staff)
      elsif staff.access_level? :hall_director
        trim_residence_life_privileges_to(:administrator, staff)
        trim_residence_life_privileges_to(:hall_director, staff)
      elsif staff.access_level? :administrative_assistant
        trim_residence_life_privileges_to(:administrator, staff)
        trim_residence_life_privileges_to(:hall_director, staff)
        trim_residence_life_privileges_to(:administrative_assistant, staff)
      elsif staff.access_level? :resident_assistant
        trim_residence_life_privileges_to(:administrator, staff)
        trim_residence_life_privileges_to(:hall_director, staff)
        trim_residence_life_privileges_to(:administrative_assistant, staff)
        trim_residence_life_privileges_to(:resident_assistant, staff)
      end

      can [:update, :show], Staff, :id => staff.id
      cannot [:destroy,:update_access_level,:update_organization], Staff, :id => staff.id
    elsif staff.organization? :academic_skills_center
      # trim or build privileges for each Academic Skills access_level here
      
    else
      # this user does not belong to an organization and is therefore not logged in
      can :landingpage, :home
    end
  end

  # removes specific residence life privileges for the specified access level
  def trim_residence_life_privileges_to(access_level_symbol, staff)
    if access_level_symbol == :administrator
      cannot [:destroy, :update, :show], Staff, :access_level => {:display_name => ["System Administrator","Administrator"]}
    
    elsif access_level_symbol == :hall_director
      cannot [:destroy, :update, :show], Staff, :access_level => {:display_name => "Hall Director"}
    
    elsif access_level_symbol == :administrative_assistant
      cannot [:destroy, :update, :show], Staff, :access_level => {:display_name => "Administrative Assistant"}
    
    elsif access_level_symbol == :resident_assistant
      cannot [:show, :update, :destroy], [Task, Staff]
      cannot [:show, :update], IncidentReport
      can [:show, :update], IncidentReport, :staff_id => staff.id, :submitted => false
      cannot [:create], Staff
      cannot [:view_student_id, :view_contact_info], Student
    end
  end
  
  # removes specific academic skills center privileges for the specified access level
  def trim_academic_skills_center_privileges_to(access_level_symbol, staff)

  end

end
