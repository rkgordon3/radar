@rails-31 @buildings @delete_buildings
Feature: System admin deleting buildings
   As a system administrator, I want to be able to delete a building
   
Background:
   Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
   And the building named Test Building exists
   When the user visits the "Manage Buildings" page
   
Scenario: A system administrator navigates to manage building link from the manage menu and clicks the Destroy link to remove a building
   Given the user selects the Destroy link on building Test Building
   Then the "Test Building" should be removed from the page
   And the building named Test Building should no longer exist
