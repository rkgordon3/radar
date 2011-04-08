class Notification
	def immediate_notify(id => report.id)
		report = report.where(:id => id)
	end

end