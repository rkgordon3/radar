class ReportType < ActiveRecord::Base
  has_many :interested_parties
  has_many :relationship_to_reports
  
  def ReportType.common_reasons
	  @@common_reasons = RelationshipToReport.where("report_type_id is null") if not defined?(@@common_reasons) or @@common_reasons.nil?
	  @@common_reasons
  end
  
  def controller_name
	name.pluralize.underscore << "_controller"
  end
 
  
  def ReportType.associated_reasons(student = nil)
	(ReportType.common_reasons + relationship_to_reports).sort 
  end

end
