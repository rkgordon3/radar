And(/^the building "(.*?)" exists$/) do |area|
	FactoryGirl.create(:building, :name => area)
end

Then(/^I should see the buildings in this order:$/) do |table|
	expected_order = table.raw
	actual_order = find(:xpath, "//*[@id='building_index']/div/div/table/tbody/tr/td[1]").collect(&:text)
	expected_order.should == actual_order
end
 
When(/^the user selects the Destroy link on "(.*?)"$/) do |building|
	within("div#building_#{Building.find_by_name(building).id}_div") do
		find_link('Destroy').click
	end
end
 
Then(/^the "(.*?)" should be removed from the page$/) do |building|
	#page.has_content?(building)
	#page.should have_no_content building
	page.should have_no_selector(:xpath, "//*[@id='building_index']/div[3]/div[1]/table/tbody/tr/td[1]")
	#//*[@id="building_index"]/div[3]/div[1]/table/tbody/tr/td[1]
end