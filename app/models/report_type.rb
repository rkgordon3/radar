class ReportType < ActiveRecord::Base
  has_many 		:interested_parties
  has_many 		:report_fields
  has_many 		:relationship_to_reports
  belongs_to	:organization
  belongs_to	:default_reason, :class_name => "RelationshipToReport", :foreign_key => :default_reason_id
  
  @log = File.new("report_type.log" , "a")
  
  def <=> other
	return self.display_name <=> other.display_name  
  end
  
  def default_contact_reason_id
    default_reason_id
  end

  def controller_name
	name.pluralize.underscore << "_controller"
  end
  
  def fields(view)
    self.report_fields.where("#{view}_position IS NOT NULL and #{view}_position > 0").order("#{view}_position")
  end

  def associated_reasons(student = nil)

    if (path_to_reason_context != nil && student != nil)
        (path_to_reason_context.constantize.for([student]) + self.org_common_reasons).sort{|a,b| a.description <=> b.description}
    else
       (self.org_common_reasons + relationship_to_reports.where(:organization_id => self.organization_id).all).sort{|a,b| a.description <=> b.description}
    end
  end
  
  def common_reasons(participant_ids)
   
    participants = Participant.find_all_by_id(participant_ids)
    if ((not path_to_reason_context.nil?) && (participants.length > 0))
	
        (path_to_reason_context.constantize.for(participants) + self.org_common_reasons).sort{|a,b| a.description <=> b.description}

    else

        associated_reasons(nil)
    end
  end
  

  def org_common_reasons
	  @org_common = RelationshipToReport.where(:report_type_id => nil, :organization_id => self.organization_id).all if not defined?(@org_common) or @org_common.nil?
	  @org_common
  end
end
