class StaffOrganization < ActiveRecord::Base
    belongs_to :staff
    belongs_to :organization
	belongs_to :access_level
end
