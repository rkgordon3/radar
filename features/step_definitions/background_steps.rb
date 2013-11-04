Given(/^the user "(.*?)" is logged in$/) do |user|
	steps %Q{
    	Given the "Residence Life" organization exists
   		And the "Resident Assistant" role exists
   		And there exists a user "#{user}" whose password is "password" with name "RA Reslife"
  	 	And "#{user}" fulfills the "Resident Assistant" role within the "Residence Life" organization
   		When the user visits the landing page
   		And "#{user}" signs in with "password"
   		Then the welcome message Hi, "RA Reslife" should be displayed
  	}

end
 
And(/^the user "(.*?)" is on duty$/) do |user|
	true
end