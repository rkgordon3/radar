class NotificationPreference < ActiveRecord::Base
	set_primary_keys :staff_id, :report_type
	belongs_to :staff
end
