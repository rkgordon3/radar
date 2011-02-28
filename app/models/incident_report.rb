class IncidentReport < Report
	has_many 	:reported_infractions
	
	def save_annotation(annot)
		if self.id == nil
			self.annotation = Annotation.new
			self.annotation.annotation = annot
		else if self.annotation_id == nil
			annotation = Annotation.new
			annotation.annotation = annot
			annotation.save
			self.annotation = annotation
			self.annotation.report_id = self.id
		else
			self.annotation.annotation = annot
		end
	end
	
	def annotation
		return self.annotation
	end
end
end
