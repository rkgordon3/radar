@ra_cannot_manage_others @rails-31 @gabe
Feature: Resident Assistance cannot manage other staff members besides themself
	As a resident assistant, I should not be able to manage any other staff members besides myself
	Background:
		Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
		And there exists a user "otherra@smumn.edu" whose password is "password" with name "Other Guy"
		And "otherra@smumn.edu" fulfills the "Resident Assistant" role within the "Resident Life" organization
	Scenario: A resident assistant wants to make sure they can edit their own account, but not others
		When the user visits the "Manage Staffs" page
		Then the text "Users" should be displayed
		And an edit link should be available for Staff with email ra@smumn.edu
		And an edit link should not be available for Staff with email otherra@smumn.edu
