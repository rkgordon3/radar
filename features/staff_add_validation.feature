@rails-31 @staff @validation @javascript @Owen
Feature: System admin add users
   As a system administrator, I want to add users
   
Background:
   Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
   When the user visits the "Manage Staffs" page
   
Scenario: A system administrator navigates to manage staff members link from the manage menu and clicks the New User link to add a new user and fills in the form correctly
   When the user selects the "New User" link
   And the user fills in the "Staff First Name" field with "Test"
   And the user fills in the "Staff Last Name" field with "User2"
   And the user fills in the "Staff Email" field with "testuser@smumn.edu"
	 And the user fills in the "Staff Password" field with "password"
	 And the user fills in the "Staff Password confirmation" field with "password"
	 And the user selects the Residence Life checkbox for Organization
	 When the user selects the "Create Staff" button
	 Then the text "User2, Test" should be displayed
   
Scenario: A system administrator navigates to manage staff members link from the manage menu and clicks the New User link to add a new user and fills in nothing except for the password fields which do not match
   When the user selects the "New User" link
	 And the user fills in the "Staff Password" field with "password"
	 And the user fills in the "Staff Password confirmation" field with "qwerty123"
	 Then the user selects the "Create Staff" button
	 And the text "You must enter your first name" should be displayed
	 And the text "You must enter your last name" should be displayed
	 And the text "You must enter an email address" should be displayed
	 And the text "Your passwords must match" should be displayed
	 And the user selects the Residence Life checkbox for Organization
	 When the user selects the "Create Staff" button
   Then the text "User2, Test" should not be displayed

Scenario: A system administrator navigates to manage staff members link from the manage menu and clicks the New User link to add a new user and fills in the form but uses an incorrectly formatted email
   When the user selects the "New User" link
   And the user fills in the "Staff First Name" field with "Test"
   And the user fills in the "Staff Last Name" field with "User2"
   And the user fills in the "Staff Email" field with "testuser@smumn"
	 And the user fills in the "Staff Password" field with "password"
	 And the user fills in the "Staff Password confirmation" field with "password"
	 And the user selects the Residence Life checkbox for Organization
	 When the user selects the "Create Staff" button
	 Then the text "You must enter a valid email address" should be displayed
	 Then the text "User2, Test" should not be displayed

Scenario: A system administrator navigates to manage staff members link from the manage menu and clicks the New User link to add a new user and fills in the form but doesn't select an organization
   When the user selects the "New User" link
   And the user fills in the "Staff First Name" field with "Test"
   And the user fills in the "Staff Last Name" field with "User2"
   And the user fills in the "Staff Email" field with "testuser@smumn.edu"
	 And the user fills in the "Staff Password" field with "password"
	 And the user fills in the "Staff Password confirmation" field with "password"
	 When the user selects the "Create Staff" button
	 Then the text "You must select at least one organization" should be displayed
	 Then the text "User2, Test" should not be displayed