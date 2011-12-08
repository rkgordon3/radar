class ReportType < ActiveRecord::Base
  has_many :interested_parties
  has_many :relationship_to_reports
  
  def ReportType.common_reasons
	  @@common_reasons = RelationshipToReport.where("report_type_id is null") if not defined?(@@common_reasons)
	  @@common_reasons
  end
  
  def controller_name
	name.pluralize.underscore << "_controller"
  end
 
  
  def associated_reasons
	ReportType.common_reasons.concat(relationship_to_reports).sort 
  end

end
