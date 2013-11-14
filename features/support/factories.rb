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

	factory :shift do |s|
		s.staff_id 0
		s.area_id 0
	end

	factory :area do |a|
		a.name 'Some Area'
		a.abbreviation 'SA'
	end

	factory :staff_area do |sa|
		sa.staff_id 0
		sa.area_id 0
	end

	factory :student do |st|
		st.first_name 'Sample'
		st.last_name 'User'
		st.full_name 'Sample User'
		st.building_id 0
	end

	factory :building do |b|
		b.name 'Sample Name'
	end

	factory :report_type do |rt|
		rt.name 'TheGuy'
		rt.display_name 'The Guy'
	end
end
