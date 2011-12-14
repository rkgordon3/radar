class ReportType < ActiveRecord::Base
  has_many :interested_parties
  has_many :report_fields
  
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

  def associated_reasons
	(ReportType.common_reasons + relationship_to_reports).sort 
  end

end
