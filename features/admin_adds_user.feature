@admin_add_user @rails-31 @gabe
Feature: Radar Administrator adds a user
	As an Administrator, I want to add a new user to the staff group
	Background:
		Given the user "admin@smumn.edu" is logged in as an "Administrator"
	Scenario: An administrator wants to add a user to the staff group
	When the user visits the "Manage Staffs" page
	Then the text "Users" should be displayed
	Then the user selects the "New User" link
	And the text "First name" should be displayed
	Then the user fills in the "Staff First name" field with "first name"
	And the user fills in the "Staff Last name" field with "last name"
	And the user fills in the "Staff Email" field with "admin@test.com"
	And the user fills in the "Staff Password" field with "password"
	And the user fills in the "Staff Password confirmation" field with "password"
	And the user selects the Residence Life checkbox for Organization
	When the user selects the "Create Staff" button
	Then the text "last name, first name" should be displayed