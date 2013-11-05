Given(/^the user "(.*?)" is logged in as an? "(.*?)"$/) do |role, user|
	steps %Q{
    Given the "Residence Life" organization exists
   	And the "#{role}" role exists
   	And there exists a user "#{user}" whose password is "password" with name "Reslife Member"
  	And "#{user}" fulfills the "#{role}" role within the "Residence Life" organization
   	When the user visits the landing page
   	And "#{user}" signs in with "password"
   	Then the welcome message Hi, "Reslife Member" should be displayed
  }
end
 
And(/^the user "(.*?)" is on duty$/) do |user|
	staff = Staff.find_by_email(user) rescue false
	shift = FactoryGirl.create(:shift,
    :staff_id => staff.id)
end

Then(/^the "(.*?)" icon should be displayed$/) do |icon|
    page.find(:xpath, "//div[@id='duty_button']//input[@type='image'][@title='#{icon}']")
end

When(/^the user fills out the shift summary with "(.*?)"$/) do |summary|
	 # Add shift to world
  steps %Q{
    When the user fills in the "" field with "#{summary}"
  }
end

Then(/^the "(.*?)" form should be displayed$/) do |form|
  	pending # express the regexp above with the code you wish you had
end

Then(/^the "(.*?)" message should be displayed$/) do |message|
  	pending # express the regexp above with the code you wish you had
end

And(/^the "(.*?)" for the current shift should be displayed$/) do |log|
  	pending # express the regexp above with the code you wish you had
end