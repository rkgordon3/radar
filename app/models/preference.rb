class Preference < ActiveRecord::Base
	scope :for_staff, lambda { |staff, name| where(:staff_id=>staff.id, :name => name) }
end
