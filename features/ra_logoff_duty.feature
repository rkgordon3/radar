@rails-31 @ra_logoff_duty
Feature: RA wants to Go Off Duty
As a Resident Assistant, I want to be able to go off duty
Background:
   Given the user "ra@smumn.edu" is logged in 
   And the user "ra@smumn.edu" is on duty
   Scenario: A Resident Assistant user is on duty and wants to go off duty
      Then the "red STOP" icon should be displayed
      When the user clicks the "red STOP" icon
      Then the "shift summary" form should be displayed
      When the user fills out the shift summary # Add shift to world
      And the user selects the "Update Shift" button
      Then the "green GO" icon should be displayed
      And the "You are now off duty" message should be displayed
      And the "duty log" for the current shift should be displayed