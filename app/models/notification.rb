class Notification
IMMEDIATE_NOTIFICATION = 1
DAILY_NOTIFICATION = 2
WEEKLY_NOTIFICATION = 3
	def Notification.immediate_notify(id)
		notify_prefs = Array.new
		
		#staff_list = Array.new
		
		report = Report.find(id)
		# Remove this reference to constant 1. WTF does it mean? Give me a name, baby!
		notify_prefs = NotificationPreference.where(:frequency => IMMEDIATE_NOTIFICATION, :report_type => report.type).all
		
		notify_prefs.each do |np|
			
			mail = RadarMailer.notification_mail({report.display_name => [report]}, Staff.find(np.staff_id))
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
	
	def Notification.notify
		plist = Array.new
		staff_ids = NotificationPreference.all(:select => 'distinct(staff_id)')
		
		staff_ids.each do |s|
			reports = Hash.new
			plist = NotificationPreference.where(:staff_id => s.staff_id, :frequency =>(DAILY_NOTIFICATION..WEEKLY_NOTIFICATION))
			notify = false
			plist.each do |p|
			notify = Notification.should_notify(p)
				if notify
					r = Report.where(:created_at => (p.last_notified..Time.now), :type => p.report_type)
					if r.first != nil
						temp_hash = {r.first.display_name => r}
						reports.merge!(temp_hash)
					end
					p.last_notified = Time.now
					p.save
				end
			end
			if notify
				mail = RadarMailer.notification_mail(reports, Staff.find(s.staff_id))
				mail.deliver
			end
		end
	end
	
	def Notification.should_notify(preference)
		if preference.frequency == WEEKLY_NOTIFICATION
			base_time = Time.now.beginning_of_week
		else 
			base_time = Time.now.beginning_of_day
		end
		t = preference.time_offset*60
		mm, ss = t.divmod(60)
		hh, mm = mm.divmod(60)
		dd, hh = hh.divmod(24)
		request_time = base_time + dd.day + hh.hour + mm.minutes + ss.seconds
		if preference.last_notified == nil
			last_notify = Time.new(1970)
			preference.last_notified = Time.new(1970)
			preference.save
		else
			last_notify = preference.last_notified
		end
		#puts last_notify
		#puts preference.last_notified
		#puts request_time
		#puts Time.now
		return (last_notify < request_time and request_time <= Time.now)
	
	end
end