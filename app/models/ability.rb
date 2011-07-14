class Ability
  include CanCan::Ability

  def initialize(staff)
    staff ||= Staff.new
    if staff.organization? :residence_life
      can :manage, :all
      if staff.access_level? :system_administrator
        #don't remove any privileges
      elsif staff.access_level? :administrator
        trim_residence_life_privileges_to(:administrator)
      elsif staff.access_level? :hall_director
        trim_residence_life_privileges_to(:administrator)
        trim_residence_life_privileges_to(:hall_director)
      elsif staff.access_level? :administrative_assistant
        trim_residence_life_privileges_to(:administrator)
        trim_residence_life_privileges_to(:hall_director)
        trim_residence_life_privileges_to(:administrative_assistant)
      elsif staff.access_level? :resident_assistant
        trim_residence_life_privileges_to(:administrator)
        trim_residence_life_privileges_to(:hall_director)
        trim_residence_life_privileges_to(:administrative_assistant)
        trim_residence_life_privileges_to(:resident_assistant)
      end
      can :update, Staff, :id => staff.id
      cannot :destroy, Staff, :id => staff.id
    elsif staff.organization? :academic_skills_center
      # trim or build privileges for each Academic Skills access_level here
      
    else
      # this user does not belong to an organization and is therefore not logged in
      can :landingpage, :home
    end
  end

  def trim_residence_life_privileges_to(access_level)
    if access_level == :administrator
      cannot [:destroy, :update], Staff, :access_level => {:display_name => ["System Administrator","Administrator"]}
    elsif access_level == :hall_director
      cannot [:destroy, :update], Staff, :access_level => {:display_name => "Hall Director"}
    elsif access_level == :administrative_assistant
      cannot [:destroy, :update], Staff, :access_level => {:display_name => "Administrative Assistant"}
    elsif access_level == :resident_assistant
      cannot [:destroy, :update], Staff, :access_level => {:display_name => "Resident Assistant"}
      cannot [:show,:update,:destroy], [Report, Student, Task, Staff]
      cannot [:view_student_id, :view_contact_info], Participant
      cannot [:update_access_level, :update_organization], Staff
    end
  end

end
