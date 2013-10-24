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

	factory :access_level do |al|
		al.name 'SampleName'
		al.display_name 'Sample Name'
	end

	factory :organization do |o|
		o.display_name 'Organization Name'
	end

	factory :residence_life_organization do |rlo|
		rlo.display_name 'Residence Life Organization'
	end
end
