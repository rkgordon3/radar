 class InterestedPartyReport < ActiveRecord::Base
  belongs_to    :report
  belongs_to    :interested_party
  belongs_to    :staff
  # parties is an array of InterestedParty objects
  # emails is away of emails
  def self.log_forwards(report, parties = nil, emails = nil, staff = nil)
    logger.debug("log_forwards with parties: #{parties}")
	if not parties.nil? 
		parties.each do |p|
			iprs = InterestedPartyReport.find_by_interested_party_id_and_report_id(p.id, report.id)
			iprs ||= InterestedPartyReport.create(:interested_party_id => p.id ,:report_id => report.id ,:times_forwarded => 0)
			iprs.times_forwarded += 1
			iprs.save
		end
    end 
	
	if (not emails.nil?) && (not staff.nil?)
		emails.each do |email| 
		  iprs = InterestedPartyReport.find_by_report_id_and_email_and_staff_id(report.id, email, staff.id)
		  iprs ||=InterestedPartyReport.create(:email => email ,:report_id => report.id ,:times_forwarded => 0, :staff_id => staff.id)
		  iprs.times_forwarded += 1
		  iprs.save
		end
	end 
  end
end
