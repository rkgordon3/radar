class ReportedInfraction < ActiveRecord::Base
	belongs_to :report
	belongs_to :participant
	belongs_to :infraction
end
