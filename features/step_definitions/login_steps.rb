Given(/^there exists a user "(.*?)" whose password is "(.*?)" with name "(.*?)"$/) do |user, password, name|
	user = FactoryGirl.create(:staff, :email=>user, 
			:password=>password, 
			:first_name=>name.split[0], 
			:last_name=>name.split[1])
end

When /^I visit the landing page$/ do
	visit('/staffs/sign_in')
end

And(/^a user "(.*?)" signs in with "(.*?)"$/) do |user, password|
	fill_in('staff[email]', :with => user)
	fill_in('staff[password]', :with => password)
	click_button('Sign in')
end

Then(/^I should see a Hi, "(.*?)" message$/) do |text|
	page.should have_content(text)
end
