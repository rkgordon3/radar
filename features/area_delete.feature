@rails-31 @delete_areas @areas @David
Feature: Sys Admin wants to delete an area
	As a Sys Admin, I want to delete an area

Background:
	Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
	And the area named Test Area exists
	When the user visits the "Manage Areas" page

Scenario: A System Administrator navigates to the manage areas link from the manage menu and clicks the Destroy link to remove an area
	Given the user selects the Destroy link on area Test Area
	Then the "Test Area" should be removed from the page
	And the area named Test Area should no longer exist