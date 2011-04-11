class Notification
	def Notification.immediate_notify(id)
		notify_prefs = Array.new
		
		#staff_list = Array.new
		
		report = Report.find(id)
		
		notify_prefs = NotificationPreference.where(:frequency => 1, :report_type => report.type).all
		
		notify_prefs.each do |np|
			
			mail = RadarMailer.immediate_notification_mail(report, Staff.find(np.staff_id))
			mail.deliver
			
			#s = Staff.find(np.staff_id)
			#staff_list << s
			
		end	
		
		#staff_list.each do |staff|
		#	mail = RadarMailer.immediate_notification_mail(report, staff)
		#	mail.deliver
		#end	
	end
end