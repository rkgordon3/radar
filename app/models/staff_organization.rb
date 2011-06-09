class StaffOrganization < ActiveRecord::Base
    belongs_to :staff
    belongs_to :organization
end
