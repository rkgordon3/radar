@rails-31 @buildings @add_buildings @javascript @David
Feature: System admin adding buildings
As a system administrator, I want to be able to add a building

Background:
    Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
    And the area named LaSalle exists
    And the building named Foo exists
    When the user visits the "Manage Buildings" page

   
Scenario: A system administrator navigates to manage building link from the manage menu and wants to add a new building
   When the user selects the "New Building" link
   And the user fills in the building name field with "Test Building"
   And the user fills in the building abbreviation field with "TBA"
   And the user selects "LaSalle" from the "areas" menu
   And the user selects the "Create" button
   Then the text "Test Building" should be displayed
   And the building named Test Building should exist
