@ra_duty @rails-31 @javascript @gabe
Feature: RA Goes on Duty
	As a Resident Assistant, I want to be able to go on duty.
  Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant" 
	Scenario: A Resident Assistant is logged in and wants to go on duty.
 	  Then the "Go On Duty" icon should be displayed
	  When the user selects the "Go On Duty" icon
	  Then the user "ra@smumn.edu" is on duty
	  And the "You are now on duty." message should be displayed
    Then the "Go Off Duty" icon should be displayed
	 
	