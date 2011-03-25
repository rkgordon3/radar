class RelationshipToReport < ActiveRecord::Base
  belongs_to :report_participant_relationship
  
  def RelationshipToReport.fyi
    fyi_id = RelationshipToReport.where(:description => "FYI")
    return fyi_id.first.id
  end
  
end
