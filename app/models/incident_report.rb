class IncidentReport < Report
	has_many 	:reported_infractions
	belongs_to	:annotations
	
	def annotation
		return self.annotation
	end
end
