Given(/^the "(.*?)" user "(.*?)" is logged in$/) do |role, user|
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