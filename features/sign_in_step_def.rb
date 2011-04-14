Given /^I am a user of RADAR$/ do
	staff = Staff.where(:email => "radar.system.admin@smumn.edu")
	staff.first.should != nil
end

When /^I sign in$/ do
	visit "/staffs/sign_in"
	fill_in "Email", :with => "radar.system.admin@smumn.edu"
	fill_in "Password", :with => "password"
	click_button "Sign in"
end

Then /^I should be directed to the landing page$/ do 
	response.should have_selector("toolbar")
end