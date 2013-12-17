@rails-31 @add_areas @areas @javascript @David @WIP
Feature: Sys Admin wants to add an area
	As a Sys Admin, I want to add an area

Background:
	Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
  	And the building named Off Campus exists
  	When the user visits the "Manage Areas" page
Scenario: A Sys Admin navigates to the manage areas link from the manage menu and wants to add a new area
   	When the user selects the "New Area" link
   	And the user fills in the "Area Name" field with "A Test Area"
   	And the user fills in the "Area Abbreviation" field with "TA"
   	And the user selects "Off Campus" from the "buildings" menu
   	And the user selects the "Create" button
   	Then the text "A Test Area" should be displayed
   	And the area named A Test Area should exist
