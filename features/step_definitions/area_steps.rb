And(/^the area "(.*?)" exists$/) do |area|
	FactoryGirl.create(:area, :name => area, :abbreviation => 'abr')
end

When(/^the user selects the Destroy link on area "(.*?)"$/) do |area|
	within("div#area_#{Area.find_by_name(area).id}_div") do
		find_link('Destroy').click
	end
end