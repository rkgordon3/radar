class ReportedInfraction < ActiveRecord::Base
	belongs_to :incident_report
	belongs_to :participant
	belongs_to :infraction
end
