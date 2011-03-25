class ReportParticipantRelationship < ActiveRecord::Base
	belongs_to :incident_report
	belongs_to :participant
	belongs_to :relationship_to_report
  
  def after_initialize
    if self.id == nil && self.relationship_to_report_id == nil
      self.relationship_to_report_id = RelationshipToReport.fyi
    end
  end
  
end
