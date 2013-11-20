@ra_cannot_manage_others
Feature: Resident Assistance cannot manage other staff members besides themself
	As a resident assistant, I should not be able to manage any other staff members besides myself
	Background:
		Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
		And there exists a user "otherra@smumn.edu" whose password is "password" with name "Reslife Member"
		And "otherra@smumn.edu" fulfills the "Resident Assistant" role within the "Resident Life" organization
	Scenario: A resident assistant wants to make sure they can edit their own account, but not others
		When the user visits the "Manage Staffs" page
		Then the text "Users" should be displayed
		And an edit link should be available for ra@smumn.edu
		And an edit link should not be available for otherra@smumn.edu
