class ReportParticipantRelationship < ActiveRecord::Base

	N_COMPONENTS_IN_DURATION = 2
  
	belongs_to :report
	belongs_to :participant
	belongs_to :relationship_to_report
    belongs_to :annotation
    before_save :save_annotation
	before_destroy :destroy_annotation
	
	attr_reader :comment
    
  after_initialize :setup_defaults
  def self.table_name() "report_participants" end
  
  def setup_defaults
    if self.id.nil? && self.relationship_to_report_id.nil?
      #self.relationship_to_report_id = RelationshipToReport.fyi
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
puts ("+++++++++++ report_participant_relationship.save_annotatiopn anno = #{self.annotation} " ) 
    self.annotation_id = annotation.id if not self.annotation.nil?
  end
  
  def destroy_annotation
    self.annotation.delete if not self.annotation.nil?
  end
  
  def comment
	annotation.text rescue ""
  end
  
  def display_contact_duration
    h = contact_duration / 60
	m = contact_duration % 60
	h.to_s + ":" + (m < 10 ? ("0"+m.to_s) : m.to_s)
  end
  
  def ReportParticipantRelationship.parse_duration(duration_string) 
	time_string = duration_string.split(":")
	return 60 if time_string.length != N_COMPONENTS_IN_DURATION
    hours = time_string[0].to_i()
    min = time_string[1].to_i()
    minutes = (hours*60) + min
  end
  
end
