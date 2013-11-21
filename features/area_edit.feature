@rails-31 @edit_areas @areas @javascript
Feature: System admin editing areas
   As a system administrator, I want to be able to edit an area
Background:
   Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
   And the building named LaSalle exists
   And the building named Watters exists
   And the area named Foo exists
   When the user visits the "Manage Areas" page
Scenario: A system administrator navigates to manage building link from the manage menu and clicks the Edit link to edit a building
   Given the user selects the Edit link on area Foo
   And the user changes the area name from Foo to Foobar
   And the user changes the area abbreviation from f to fb
   And the user selects LaSalle from the buildings menu
   And the user selects the "Save" button
   Then the area named Foobar should exist