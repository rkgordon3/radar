@rails-31 @ra_manages_mr @reports @javascript @dylan
Feature: RA wants to create and manage a maintenance report
As a Resident Assistant, I want to be able to create and manage a maintenance report
Background:
   	Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   	When the user visits the New Maintenance Report page
   	Then the text "New Maintenance Report" should be displayed
   	When the user fills in the "Report Annotation" field with "There's a leak."
   		Scenario: A Resident Assistant user wants to submit a maintenance report.
      		And the user selects the "Submit Report" button
      		When the user visits the "Maintenance Report" report page
      		Then the user's most recent "Maintenance Report" report should be displayed

   		Scenario: A Resident Assistant user wants to save a maintenance report.
      		And the user selects the "Save Report" button
      		When the user visits the "Maintenance Report" report page
      		Then the user's most recent "Maintenance Report" report should be displayed