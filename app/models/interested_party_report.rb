class InterestedPartyReport < ActiveRecord::Base
  belongs_to    :report
  belongs_to    :interested_party
  
  def self.log_forwards(report, parties)
    logger.debug("log_forwards with parties: #{parties}")
	parties.each do |p|
        iprs = InterestedPartyReport.find_by_interested_party_id_and_report_id(p.id, report.id)
        iprs ||= InterestedPartyReport.create(:interested_party_id => p.id ,:report_id => report.id ,:times_forwarded => 0)
        iprs.times_forwarded += 1
        iprs.save
    end
  end
end
