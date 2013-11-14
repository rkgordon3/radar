@rails-31 @add_areas @areas
Feature: Sys Admin wants to add an area
	As a Sys Admin, I want to add an area

Background:
	Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
    When the user visits the "Manage Areas" page
    And the building "Test Building" exists

Scenario: A Sys Admin navigates to the manage areas link from the manage menu and wants to add a new area
   When the user selects the "New Area" js link
   And the user fills in the "area_name" field with "Test Area"
   And the user fills in the "area_abbreviation" field with "TA"
   And the user selects "Test Building" from the "buildings" menu
   And the user selects the "Create" button
   Then the text "Test Area" should be displayed
