class NotificationPreferencesController < ApplicationController
  before_filter :hd_authorize_view_access  
  skip_before_filter :verify_authenticity_token
  acts_as_iphone_controller = true 
 
 # GET /notification_preferences
  # GET /notification_preferences.xml
  def index
  	@notification_preferences = Array.new
	ReportType.find(:all).collect.each do |r|
		pref = NotificationPreference.find(current_staff.id,r.name) rescue nil
		if(pref == nil)
			pref = NotificationPreference.new(:staff_id => current_staff.id, :report_type => r.name)
		end
		@notification_preferences << pref
	end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notification_preferences }
    end
  end

  # PUT
  def update_user_preferences
	ReportType.find(:all).collect.each do |r|
		pref = NotificationPreference.find(current_staff.id,r.name) rescue nil
		if(pref == nil)
			pref = NotificationPreference.new(:staff_id => current_staff.id, :report_type => r.name)
		end
		pref.update_attributes(params["#{current_staff.id},#{r.name}"])
		pref = NotificationPreference.find(current_staff.id,r.name) rescue nil
		if(pref.frequency == 2)
			logger.debug "2"
			pref.time_offset = 480
		end
		if(pref.frequency == 3)
			logger.debug "3"
			pref.time_offset = 1920
		end
		if(pref.frequency == 1)
			pref.time_offset = -1
		end
		pref.save
		if(pref.frequency == 0)
			pref.delete
		end
	end

    respond_to do |format|
      if true
        format.html { redirect_to('/home/landingpage/', :notice => 'Your Notification Preferences were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @notification_preference.errors, :status => :unprocessable_entity }
      end
    end
  end
end
