class ReportParticipantRelationship < ActiveRecord::Base
	belongs_to :report
	belongs_to :participant
	belongs_to :relationship_to_report
    belongs_to :annotation
    before_save :save_annotation
	
	attr_reader :comment
    
  after_initialize :setup_defaults
  def self.table_name() "report_participants" end
  
  def setup_defaults
    if self.id.nil? && self.relationship_to_report_id.nil?
      self.relationship_to_report_id = RelationshipToReport.fyi
    end
  end
  
  def reason
    self.context.nil? ? relationship_to_report : self.context.constantize.where(:id => self.relationship_to_report_id).first
  end
  #
  # Test whether this report/participant relationship is result of a 'generic'
  # reason. A generic reason is not associated with any specific report, e.g. Other
  # The actual test tests whether 'reason' has a 'report_type_id' property. Those
  # 'generic' properties do, other 'contextual' reasons do not. 
  #
  # This is not a very good solution and needs to be revisited.
  #
  def for_generic_reason?
    reason.respond_to?(:report_type_id) 
  end
  
  def save_annotation   
    self.annotation_id = annotation.id if not self.annotation.nil?
  end
  
  def comment
	annotation.text rescue ""
  end
end
