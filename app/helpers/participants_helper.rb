module ParticipantsHelper
  class ContactSummary
	attr_accessor :report
	attr_accessor :date
	attr_accessor :reason
	
	def <=> other_contact
	  r = self.date <=> other_contact.date
	  puts "#{self.date} vs #{other_contact.date} returns #{r}"
	  r
	end
  end
end
