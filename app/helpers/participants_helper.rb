module ParticipantsHelper
  class ContactSummary
	attr_accessor :report
	attr_accessor :date
	attr_accessor :reason
	
	def <=> other_contact
	  self.date <=> other_contact.date
	end
  end
end
