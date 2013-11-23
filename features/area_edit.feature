@rails-31 @edit_areas @areas @javascript @David
Feature: System admin editing areas
   As a system administrator, I want to be able to edit an area
Background:
   Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
   And the building named LaSalle exists
   And the building named Watters exists
   And the area named Foo exists
   When the user visits the "Manage Areas" page
Scenario: A system administrator navigates to manage area link from the manage menu and clicks the Edit link to edit a area
   Given the user selects the Edit link on area Foo
   And the user fills in the area name field with "Foobar"
   And the user fills in the area abbreviation field with "fb"
   And the user selects "LaSalle" from the "buildings" menu
   And the user selects the "Save" button
   Then the text "Foobar" should be displayed
   Then the area named Foobar should exist