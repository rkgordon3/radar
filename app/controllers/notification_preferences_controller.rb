class NotificationPreferencesController < ApplicationController
  before_filter :general_authorize  
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
