@rails-31 @ra_logoff_duty @javascript
Feature: RA wants to Go Off Duty
As a Resident Assistant, I want to be able to go off duty
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   And the user selects the "Go On Duty" icon  
   And the user "ra@smumn.edu" is on duty
   Scenario: A Resident Assistant user is on duty and wants to go off duty
      Then the "Go Off Duty" icon should be displayed
      When the user selects the "Go Off Duty" icon
      Then the "shift summary" form should be displayed
      When the user fills out the shift summary with "Tonight was a great night on duty."
      And the user selects the "Update Shift" button
      Then the "Go On Duty" icon should be displayed
      And the "You are now off duty. Your shift has been logged." message should be displayed
      And the "duty log" for the current shift should be displayed