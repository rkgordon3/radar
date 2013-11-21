And(/^the user selects "(.*?)" from the auto-suggestion field$/) do |selection|
 	page.find(:xpath, "//li[@class='ui-menu-item']/a['#{selection}']").click
end

And(/^an? "(.*?)" exists for student "(.*?)"$/) do |report_type, student|
	report_link = report_type.split.join("_").downcase.to_sym
	FactoryGirl.create(report_link, :submitted => 'true')
	FactoryGirl.create(:report_participant_relationship, :participant_id => Student.find_by_full_name(student).id, :report_id => report_type.delete(' ').first)
end

And(/^an? "(.*?)" submitted by "(.*?)" exists for building "(.*?)"$/) do |report_type, staff, building|
	report_link = report_type.split.join("_").downcase.to_sym
	puts Building.find_by_name(building).id
	FactoryGirl.create(report_link, :submitted => 'true', :building_id => Building.find_by_name(building).id, :staff_id => Staff.find_by_email(staff).id)
end

And(/^the "(.*?)" report for "(.*?)" should be displayed$/) do |report_type, building|
	b_id = Building.find_by_name(building).id
	r_id = report_type.delete(' ').constantize.find_by_building_id(b_id).id
	page.should have_content("R-#{r_id}")
end

And(/^the "(.*?)" report for "(.*?)" should not be displayed$/) do |report_type, building|
	b_id = Building.find_by_name(building).id
	r_id = report_type.delete(' ').constantize.find_by_building_id(b_id).id
	page.should_not have_content("R-#{r_id}")
end