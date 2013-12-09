And(/^an? "(.*?)" exists for student "(.*?)"$/) do |report_type, student|
	report_link = report_type.split.join("_").downcase.to_sym
	FactoryGirl.create(report_link, :submitted => 'true', :organization_id => get_current_organization.id, :staff_id => get_current_user.id, :type => report_type.delete(" "))
	FactoryGirl.create(:report_participant_relationship, :participant_id => Student.find_by_full_name(student).id, :report_id => report_type.delete(' ').constantize.first.id)
end

And(/^an? "(.*?)" submitted by "(.*?)" exists for building "(.*?)"$/) do |report_type, staff, building|
	report_link = report_type.split.join("_").downcase.to_sym
	FactoryGirl.create(report_link, :submitted => 'true', :building_id => Building.find_by_name(building).id, :staff_id => Staff.find_by_email(staff).id)
end

And(/^the "(.*?)" report for student "(.*?)" should be displayed$/) do |report_type, student_name|
	sleep 10
	s_id = Student.find_by_full_name(student_name).id
	rtr = ReportParticipantRelationship.find_by_participant_id(s_id)
	puts rtr.report_id
	r = report_type.delete(' ').constantize.find(rtr.report_id)
	page.should have_content("#{r.tag}")
end

And(/^the "(.*?)" report for "(.*?)" (should|should not) be displayed$/) do |report_type, building, polarity|
	b_id = Building.find_by_name(building).id
	r = report_type.delete(' ').constantize.find_by_building_id(b_id)
	polarity = polarity.split.join("_")
	page.send(polarity, have_content("#{r.tag}"))
end

Then(/^the user's most recent "(.*?)" report should be displayed$/) do |report_type|
	within(:xpath, "//div[@id='results']") do
		page.should have_content("#{most_recent_for(get_current_user.email, report_type)[0].tag}")
	end
end

Then(/^the user's most recent "(.*?)" report should be displayed in the "(.*?)" section$/) do |report_type, section|
  	within(:xpath, "//div[@id='#{section.downcase}']") do
      page.should have_content("#{most_recent_for(get_current_user.email, report_type)[0].tag}")
    end
end

Then(/^the user "(should|should not)" be able to view their most recent "(.*?)" report$/) do |polarity, report_type|
    sleep 2
    polarity = polarity.split.join("_")
    page.send(polarity, have_link("#{most_recent_for(get_current_user.email, report_type)[0].tag}"))
end

When(/^the user visits the show page for their most recent "(.*?)" report$/) do |report_type|
  	visit("/#{report_type.split.join("_").downcase.pluralize}/#{most_recent_for(get_current_user.email, report_type)[0].id}")
end

