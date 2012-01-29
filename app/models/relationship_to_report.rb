class RelationshipToReport < ActiveRecord::Base
  belongs_to :report_type
  
  def RelationshipToReport.fyi
    @@fyi_id = RelationshipToReport.where(:description => "FYI") if not defined?(@@fyi_id)
    return @@fyi_id.first.id
  end
  
  def RelationshipToReport.maintenance_concern
    @@mc_id = RelationshipToReport.where(:description => "Maintenance Concern") if not defined?(@@mc_id)
    return @@mc_id.first.id
  end
  
  def <=> other
	return  1 if other.id == RelationshipToReport.fyi 
	return -1 if self.id == RelationshipToReport.fyi
	return self.description <=> other.description  
  end
end