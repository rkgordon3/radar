@admin_add_user @rails-31
Feature: Radar Administrator adds a user
	As an Administrator, I want to add a new user to the staff group
	Background:
		Given the user "admin@smumn.edu" is logged in as an "Administrator"
	Scenario: An administrator wants to add a user to the staff group
	When the user visits the "Manage Staffs" page
	Then the text "Users" should be displayed
	Then the user selects the "New User" link
	And the text "First name" should be displayed
	Then the user fills in the "First name" field with "first name"
	And the user fills in the "Last name" field with "last name"
	And the user fills in the "Email" field with "admin@test.com"
	And the user fills in the "Password" field with "password"
	And the user fills in the "Password confirmation" field with "password"
	And the Residence Life Organization is selected
	When the user selects the "Create Staff" button
	Then the text "last name, first name" should be displayed