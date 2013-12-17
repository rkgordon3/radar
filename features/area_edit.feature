@rails-31 @edit_areas @areas @javascript @David @WIP
Feature: System admin editing areas
   As a system administrator, I want to be able to edit an area
Background:
   Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
   And the building named Off Campus exists
   And the area named A Test Area exists
   When the user visits the "Manage Areas" page
   Scenario: A system administrator navigates to manage area link from the manage menu and clicks the Edit link to edit a area
      Given the user selects the Edit link on area A Test Area
      And the user fills in the "Area Name" field with "Foobar"
      And the user fills in the "Area Abbreviation" field with "fb"
      And the user selects "Off Campus" from the "buildings" menu
      And the user selects the "Save" button
      Then the text "Foobar" should be displayed
      Then the area named Foobar should exist