class ReportParticipantRelationship < ActiveRecord::Base
	belongs_to :report
	belongs_to :participant
	belongs_to :relationship_to_report
    belongs_to :annotation
    before_save :save_annotation
    
  after_initialize :setup_defaults
  def self.table_name() "report_participants" end
  
  def setup_defaults
    if self.id == nil && self.relationship_to_report_id == nil
      self.relationship_to_report_id = RelationshipToReport.fyi
    end
  end
  
  def relationship_to_report
    if self.context != nil
        self.context.constantize.where(:id => self.relationship_to_report_id).first
    else
        RelationshipToReport.where(:id => self.relationship_to_report_id).first
    end
  end
  
  def save_annotation
    if self.annotation != nil
        self.annotation_id = annotation.id
    end
  end
end
