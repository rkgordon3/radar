Given /^I am a user of RADAR$/ do
	staff = Staff.where(:email => "radar.system.admin@smumn.edu")
	staff.first.first_name.should == "System"
end

When /^I sign in$/ do
	visit "/staffs/sign_in"
	fill_in "Email", :with => "radar.system.admin@smumn.edu"
	fill_in "Password", :with => "password"
	click_button "Sign in"
end

Then /^I should see the landing page$/ do   
  page.should have_content("Hi, System Administrator")
end