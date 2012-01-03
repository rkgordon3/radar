class ReportType < ActiveRecord::Base
  has_many 		:interested_parties
  has_many 		:report_fields
  has_many 		:relationship_to_reports
  belongs_to	:organization
  
  def <=> other
	return self.display_name <=> other.display_name  
  end
  
  def ReportType.common_reasons
	  @@common_reasons = RelationshipToReport.where("report_type_id is null") if not defined?(@@common_reasons) or @@common_reasons.nil?
	  @@common_reasons
  end
  
  def controller_name
	name.pluralize.underscore << "_controller"
  end
  
  def fields(view)
    self.report_fields.where("#{view}_position IS NOT NULL and #{view}_position > 0").order("#{view}_position")
  end

  def associated_reasons(student = nil)
    if (path_to_reason_context != nil && student != nil)
        (path_to_reason_context.constantize.for([student]) + ReportType.common_reasons).sort{|a,b| a.description <=> b.description}
    else
        (ReportType.common_reasons + relationship_to_reports).sort{|a,b| a.description <=> b.description}
    end
  end
  
  def common_reasons(participant_ids)
    participants = Participant.find_all_by_id(participant_ids)
    if (path_to_reason_context != nil && participant_ids.size > 0)
        (path_to_reason_context.constantize.for(participants) + ReportType.common_reasons).sort{|a,b| a.description <=> b.description}
    else
        associated_reasons(nil)
    end
  end
end
