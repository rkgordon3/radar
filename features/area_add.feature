@rails-31 @add_areas @areas @javascript @David
Feature: Sys Admin wants to add an area
	As a Sys Admin, I want to add an area

Background:
	Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
  And the building named Test Building exists
  When the user visits the "Manage Areas" page

Scenario: A Sys Admin navigates to the manage areas link from the manage menu and wants to add a new area
   When the user selects the "New Area" link
   And the user fills in the area name field with "Test Area"
   And the user fills in the area abbreviation field with "TA"
   And the user selects "Test Building" from the "buildings" menu
   And the user selects the "Create" button
   Then the text "Test Area" should be displayed
   And the area named Test Area should exist
