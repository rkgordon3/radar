class RelationshipToReport < ActiveRecord::Base
  belongs_to :report_participant_relationship
  
  def RelationshipToReport.fyi
    fyi_id = RelationshipToReport.where(:description => "FYI")
    return fyi_id.first.id
  end
  
  def RelationshipToReport.maintenance_concern
    mc_id = RelationshipToReport.where(:description => "Maintenance Concern")
    return mc_id.first.id
  end
  
end
