Given /^a user "(.*?)" exists as role "(.*?)" in "(.*?)" organization$/ do |user, role, org|
  fname,lname = user.tableize.singularize.split("_")
  lname =~ /^(\w+)@.*/ 
  user = FactoryGirl.create(:staff, :email=>user, 
			:password=>"password", 
			:first_name=>fname.capitalize, 
			:last_name=>$~.captures[0].capitalize)
  level = AccessLevel.find_by_name(role)
  organization = Organization.find_by_display_name(org)
  FactoryGirl.create(:staff_organization, 
		:staff_id=>user.id, 
		:access_level_id=>level.id, 
		:organization_id=>organization.id)
  
end

Given /^I have visited signin page$/ do
  visit(Capybara.app_host)
  find_link("Sign In").visible?
end

Given /^I have clicked signin link$/ do
  click_link("Sign In")
end

Then /^I am on login page$/ do
  page.should have_selector(:xpath, "//form[@id='staff_new']")
  page.should have_selector(:xpath, "//form//label[@for='staff_email']")
  page.should have_selector(:xpath, "//form//label[@for='staff_password']")
end


Then /^I enter credentials for "(.*?)"$/ do |user|
  fill_in "staff[email]", :with => user
  fill_in "staff[password]", :with => "password"
end

When /^I click login$/ do
  click_button("Sign in")
end

Then /^I should be on landing page for "(.*?)"$/ do |user| 
  user = Staff.find_by_email(user.downcase)
  name = user.first_name + " " + user.last_name
  /\w+#{name}\w+/.match(
		   find(:xpath, "//div[@id='sign_out_link']//b").text)
  /\w+#{name}'s Unsubmitted Reports/.match(
		   find(:xpath, "//div[@id='inside_container']/h3").text)
end

And /^the following selections should be visible$/ do |selections|
  sel_size = selections.raw.length
  selections.raw
	    .flatten
	    .slice(1, sel_size)
	    .select { |x| find_link(x).visible? }
	    .size.should == sel_size - 1
end

Then /^there is a submenu "(.*?)"$/ do |submenu|
  page.has_selector?(:submenu, submenu)
end

