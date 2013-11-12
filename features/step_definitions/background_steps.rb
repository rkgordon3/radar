Given(/^the user "(.*?)" is logged in as an? "(.*?)"$/) do |user, role|
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
  page.should have_content("Go Off Duty")
	staff = Staff.find_by_email(user) rescue false
	shift = Shift.find_by_staff_id(staff.id) rescue false
  staff.id == shift.staff_id
end

And(/the text "(.*?)" should be displayed$/) do |text|
  page.should have_content(text)
end

Then(/^the "(.*?)" icon should be displayed$/) do |icon|
  page.find(:xpath, "//input[@type='image'][@title='#{icon}']")
end

When(/^the user fills out the shift summary with "(.*?)"$/) do |summary|
	 # Add shift to world
  steps %Q{
    When the user fills in the "annotation_text" field with "#{summary}"
  }
end

Then(/^the "(.*?)" form should be displayed$/) do |form|
    if form.eql?("shift summary")
      visit '/shifts/end_shift'
    end
    #puts "looking for the form page", page.html
    page.find(:xpath, "//div[@class='field']//textarea[@id='annotation_text']")
end

Then(/^the "(.*?)" message should be displayed$/) do |message|
  	page.should have_content message
end

And(/^the "(.*?)" for the current shift should be displayed$/) do |log|
    page.should have_content 'Reports Submitted (0)'
    page.should have_content 'Tasks Assigned (0)'
end


And(/^the "(.*?)" is on the list "(.*?)" page$/) do |user, page|
  staff = Staff.find_by_email(user) rescue false
  visit("/#{page}")
end

And(/^the student "(.*?)" lives in "(.*?)"$/) do |name, residence|
  building = FactoryGirl.create(:building, :name => residence)
  student = FactoryGirl.create(:student, :first_name => name, :last_name => name, :building_id => building.id)
end
