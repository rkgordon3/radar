@rails-31 @edit_buildings @buildings @javascript @David @Owen @WIP
Feature: System admin editing buildings
   As a system administrator, I want to be able to edit a building
Background:
   Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
   And the area named St. Benilde exists
   And the building named Test Building exists
   When the user visits the "Manage Buildings" page
Scenario: A system administrator navigates to manage building link from the manage menu and clicks the Edit link to edit a building
   Given the user selects the Edit link on building Test Building
   And the user fills in the "Building Name" field with "Edited Building"
   And the user fills in the "Building Abbreviation" field with "Eb"
   And the user selects "St. Benilde" from the "areas" menu
   And the user selects the "Save" button
   Then the text "Edited Building" should be displayed
   Then the building named Edited Building should exist