class RelationshipToReport < ActiveRecord::Base
  belongs_to :report_type
  
  def save
    # force report_type_id to nil if pseudo-value represented 'all' is present
	logger.debug("****************Saving report_type_id = #{report_type_id}")
	flag = (report_type_id == ReportTypesHelper::all_id)
	logger.debug("TEST = #{flag}")
    self.report_type_id = nil if report_type_id == ReportTypesHelper::all_id
	super
  end
  
  def RelationshipToReport.fyi
    fyi_id = RelationshipToReport.where(:description => "FYI")
    return fyi_id.first.id
  end
  
  def RelationshipToReport.maintenance_concern
    mc_id = RelationshipToReport.where(:description => "Maintenance Concern")
    return mc_id.first.id
  end
  
  def RelationshipToReport.for (report)
    where(:report_type_id => ReportType.find_by_name(report.type).id)
  end
  
  def <=> other
    self.description <=> other.description
  end
  
  
end