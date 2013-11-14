@rails-31 @delete_buildings
Feature: System admin wants to delete a building
   As a system administrator, I want to delete a building
   
Background:
   Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
   And the building "Test Building" exists
   And the "radar-admin@smumn.edu" is on the list "buildings" page
   
Scenario: A system administrator navigates to manage building link from the manage menu and clicks the Destroy link to remove a building
   Given the user selects the Destroy link on building "Test Building"
   Then the "Test Building" should be removed from the page