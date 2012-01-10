class AcademicSkillsCenterOrganization < Organization 
  MY_REPORTS = [TutorReport, TutorByAppointmentReport, Note]
  MY_REPORT_TYPES = ["TutorReport", "TutorByAppointmentReport", "Note"]
  private
  
  def system_administrator(ability, staff)
  	ability.can :assign, AccessLevel, :name => ["Administrator", "AdministrativeAssistant", "Supervisor", "Staff"]
    ability.can [:index, :search, :view_contact_history], Participant
	ability.can :search, Report
	# Can register users in this organization
	ability.can :register, Organization, :id => self.id	  
	# Limit access to those reports in this organization
    ability.can [:create, :read, :update, :search, :add_participant], MY_REPORTS, :organization_id => self.id
	ability.can [:read], Staff
	ability.can :update, Staff, :id => staff.id
	ability.can [:create, :update, :destroy], Staff, 
                 	{ 
					  :organizations => { :id => self.id },
					  :access_level  => {:display_name => ["Administrator", "Administrative Assistant", "Supervisor", "Staff"]}
					} 
	ability.can [:search], ReportType, { :name => ["TutorReport" , "TutorByAppointmentReport" ] }
  end
    
  def supervisor(ability, staff)
	ability.can [:create, :search, :read], Report, { :type => MY_REPORT_TYPES  }
	ability.can [:index, :search, :view_contact_history], Participant
	ability.can [:index], Report, { :type => ["TutorReport" , "TutorByAppointmentReport" , "Note" ]  }
	ability.can [:search, :read, :create, :update, :add_participant], MY_REPORTS, :staff_id => staff.id 	  
	# Can index staff within my organization
    ability.can :index, Staff, :organizations => { :id => self.id }
	ability.can [:update, :show], Staff, :id => staff.id    
	ability.can [:search], ReportType, { :name => ["TutorReport" , "TutorByAppointmentReport" ] }
  end
  
  def staff(ability, staff)
      puts ( "*********Apply abilities to staff")
	ability.can [:index, :search], Participant


    ability.can [:create, :search, ], Report, { :type => MY_REPORT_TYPES }
	ability.can [:create, :search, :update,:index], Note
	ability.can [:index, :search, :read, :add_participant, :remove_participant, :create_participant_and_add_to_report], 
	             Report,
				{ :type => MY_REPORT_TYPES, :staff_id => staff.id } 
    ability.can [:update], Report, { :staff_id => staff.id,  :type => MY_REPORT_TYPES, :submitted => false }
	ability.can [:index, :update], TutorReport, { :staff_id => staff.id  }
	# Can index staff within my organization
    ability.can :index, Staff, :organizations => { :id => self.id }
	ability.can [:update, :show], Staff, :id => staff.id


    ability.can [:search], ReportType, { :name => MY_REPORT_TYPES }
  end
end