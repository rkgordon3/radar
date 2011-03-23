class IncidentReport < Report
	has_many 	:reported_infractions
	belongs_to	:annotation
	
	def annotation
		return self.annotation
	end
end
