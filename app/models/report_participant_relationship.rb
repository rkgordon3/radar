class ReportParticipantRelationship < ActiveRecord::Base
	belongs_to :incident_report
	belongs_to :participant
	belongs_to :relationship_to_report
  after_initialize :setup_defaults
  
  def setup_defaults
    if self.id == nil && self.relationship_to_report_id == nil
      self.relationship_to_report_id = RelationshipToReport.fyi
    end
  end
  
end
