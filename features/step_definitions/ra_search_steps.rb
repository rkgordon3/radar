And(/^the user selects "(.*?)" from the auto-suggestion field$/) do |selection|
 	page.find(:xpath, "//li[@class='ui-menu-item']/a['#{selection}']").click
end

And(/^an? "(.*?)" exists for student "(.*?)"$/) do |report_type, student|
	report_link = report_type.split.join("_").downcase.to_sym
	FactoryGirl.create(report_link, :submitted => 'true')
	FactoryGirl.create(:report_participant_relationship, :participant_id => Student.find_by_full_name(student).id, :report_id => report_type.delete(' ').first)
end