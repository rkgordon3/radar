@rails-31 @buildings @delete_buildings @javascript
Feature: System admin deleting buildings
   As a system administrator, I want to cancel a building deleltion
   
Background:
   Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
   And the building named Test Building exists
   When the user visits the "Manage Buildings" page
   
Scenario: A system administrator navigates to manage building link from the manage menu and clicks the Destroy link to remove a building and then clicks cancel on the alert which pops up
   Given I expect to click "Cancel" on a confirmation box saying "Are you sure?"
   Then the user selects the Destroy link on building Test Building
   Then the confirmation box should have been displayed
   Then the text "Test Building" should be displayed
   And the building named Test Building should exist
   
Scenario: A system administrator navigates to manage building link from the manage menu and clicks the Destroy link to remove a building and then clicks ok on the alert which pops up
   Given I expect to click "OK" on a confirmation box saying "Are you sure?"
   Then the user selects the Destroy link on building Test Building
   Then the confirmation box should have been displayed
   Then the "Test Building" should be removed from the page
   And the building named Test Building should no longer exist