

When(/^the user selects the Destroy link on area "(.*?)"$/) do |area|
	within("div#area_#{Area.find_by_name(area).id}_div") do
		find(".destroy_link").click
	end
end