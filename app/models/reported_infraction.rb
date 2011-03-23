class ReportedInfraction < ActiveRecord::Base
	belongs_to :incident_report
	belongs_to :participant
	belongs_to :infraction
  
  def after_initialize
    if self.id == nil && self.infraction_id == nil
      self.infraction_id = Infraction.fyi
    end
  end
  
end
