@rails-31 @delete_areas_dialog @areas @javascript @Owen @WIP
Feature: Sys Admin wants to cancel an in-process area deletion
	As a Sys Admin, I want to cancel an area deleltion

Background:
	Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
	And the area named Test Area exists
	When the user visits the "Manage Areas" page
	
Scenario: A System Administrator navigates to the manage areas link from the manage menu and clicks the Destroy link to remove an area and then clicks Cancel on the alert which pops up
	Given I expect to click "Cancel" on a confirmation box saying "Are you sure?"
	Then the user selects the Destroy link on area Test Area
	Then the confirmation box should have been displayed
	Then the text "Test Area" should be displayed
	And the area named Test Area should exist
	
Scenario: A System Administrator navigates to the manage areas link from the manage menu and clicks the Destroy link to remove an area and then clicks OK on the alert which pops up
	Given I expect to click "OK" on a confirmation box saying "Are you sure?"
	Then the user selects the Destroy link on area Test Area
	Then the confirmation box should have been displayed
	Then the text "Test Area" should not be displayed
	And the area named Test Area should no longer exist
