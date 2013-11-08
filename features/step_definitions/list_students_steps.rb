Then(/^the text "(.*?)" should be displayed$/) do |text|
	page.should have_content("#{text}")
end

Then(/^I should see the students in this order:$/) do |table|
	expected_order = table.raw
	actual_order = Array.new
	for i in 0..1
		actual_order << page.all(:xpath, "//*[@id='inside_container']/table/tr[#{i+2}]/td[4]").collect(&:text)
	end
	actual_order.should == expected_order
end

Then(/^the students are listed by building in this order:$/) do |table|
	expected_order = table.raw
	actual_order = Array.new
	for i in 0..1
		actual_order << page.all(:xpath, "///*[@id='inside_container']/table/tr[#{i+2}]/td[5]").collect(&:text)
	end
	actual_order.should == expected_order
end