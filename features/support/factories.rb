require 'factory_girl'

FactoryGirl.define do
	factory :staff do |s|
	  s.email 'SampleUser@smumn.edu'
	  s.first_name 'Sample'
	  s.last_name 'User'
	  s.active true
	end

	factory :staff_organization do |so|
	  so.staff_id 0
	  so.organization_id 0
	  so.access_level_id 0
	end
end
