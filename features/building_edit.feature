@rails-31 @edit_buildings @buildings @javascript
Feature: System admin editing buildings
   As a system administrator, I want to be able to edit a building
Background:
   Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
   And the area named LaSalle exists
   And the area named Watters exists
   And the building named Foo exists
   When the user visits the "Manage Buildings" page
Scenario: A system administrator navigates to manage building link from the manage menu and clicks the Edit link to edit a building
   Given the user selects the Edit link on building Foo
   And the user changes the building name from Foo to Foobar
   And the user changes the building abbreviation from f to fb
   And the user selects "LaSalle" from the "building_area" menu
   And the user selects the "Save" button
   Then the area named Foobar should exist