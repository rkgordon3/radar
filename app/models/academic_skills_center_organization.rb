class AcademicSkillsCenterOrganization < Organization 
  MY_REPORTS = [TutorReport, TutorByAppointmentReport]
  MY_REPORT_TYPES = ["TutorReport", "TutorByAppointmentReport"]
  private
  
  def system_administrator(ability, staff)
  	ability.can :assign, AccessLevel, :name => ["Administrator", "AdministrativeAssistant", "Supervisor", "Staff"]
    ability.can [:index, :search, :view_contact_info, :view_contact_history, :show], Participant
    ability.can :search, MY_REPORTS
    ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
    ability.can [:select], ReportType, { :name => MY_REPORT_TYPES }
    # Can register users in this organization
    ability.can :register, Organization, :id => self.id
    # Limit access to those reports in this organization
    ability.can [:create, :read, :show, :index, :update, :search, :pdf], Report, {:type => MY_REPORT_TYPES} 

    ability.can [:read], Staff
    ability.can :update, Staff, :id => staff.id
    ability.can [:create, :update, :destroy], Staff,
      {
      :organizations => { :id => self.id },
      :access_levels  => {:display_name => ["Administrator", "Administrative Assistant", "Supervisor", "Staff"]}
    }
    ability.can [:select], ReportType, { :name => MY_REPORT_TYPES }
  end
    
  def supervisor(ability, staff)
    ability.can [:index, :pdf, :show, :create, :search, :read], Report, { :type => MY_REPORT_TYPES  }
    ability.can [:index, :search, :view_contact_info, :view_contact_history, :show], Participant
    ability.can :read, ReportParticipantRelationship, { :report => {:type => MY_REPORT_TYPES} }
    ability.can [:search, :read, :create, :update, :add_participant], MY_REPORTS, :staff_id => staff.id
    # Can index staff within my organization
    ability.can :index, Staff, :organizations => { :id => self.id }
    ability.can [:update, :show], Staff, :id => staff.id
    ability.can [:select], ReportType, { :name => MY_REPORT_TYPES }
  end
  
  def staff(ability, staff)
    puts ( "*********Apply abilities to staff")

    ability.can [:index, :search, :show], Participant


    ability.can [:create, :search ], Report, { :type => MY_REPORT_TYPES }
    ability.can [:create, :search, :update,:index], Note
    ability.can [:index, :show, :read, :add_participant, :remove_participant, :create_participant_and_add_to_report],
      Report,
      { :type => MY_REPORT_TYPES, :staff_id => staff.id }
    ability.can [:update], Report, { :staff_id => staff.id,  :type => MY_REPORT_TYPES, :submitted => false }
    ability.can [:index, :update], TutorReport, { :staff_id => staff.id  }
    # Can index staff within my organization
    ability.can :index, Staff, :organizations => { :id => self.id }
    ability.can [:update, :show], Staff, :id => staff.id


    ability.can [:select], ReportType, { :name => MY_REPORT_TYPES }

  end
end