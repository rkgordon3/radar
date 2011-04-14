class Notification
	def Notification.immediate_notify(id)
		notify_prefs = Array.new
		
		#staff_list = Array.new
		
		report = Report.find(id)
		# Remove this reference to constant 1. WTF does it mean? Give me a name, baby!
		notify_prefs = NotificationPreference.where(:frequency => 1, :report_type => report.type).all
		
		notify_prefs.each do |np|
			
			mail = RadarMailer.immediate_notification_mail(report, Staff.find(np.staff_id))
			begin
			  mail.deliver
      rescue 
      end
			
			#s = Staff.find(np.staff_id)
			#staff_list << s
			
		end	
		
		#staff_list.each do |staff|
		#	mail = RadarMailer.immediate_notification_mail(report, staff)
		#	mail.deliver
		#end	
	end
end