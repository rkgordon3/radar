@rails-31 @hd_manages_mr @reports @javascript @dylan
Feature: HD wants to create and manage a maintenance report
As a Hall Director, I want to be able to create and manage a maintenance report
Background:
   	Given the user "hd@smumn.edu" is logged in as a "Hall Director"
   	When the user visits the New Maintenance Report page
   	Then the text "New Maintenance Report" should be displayed
   	When the user fills in the "Report Annotation" field with "There's a leak."
   		Scenario: A Hall Director user wants to submit a maintenance report.
      		And the user selects the "Submit Report" button
      		When the user visits the "Maintenance Report" report page
      		Then the user's most recent "Maintenance Report" report should be displayed

   		Scenario: A Hall Director user wants to save a maintenance report.
      		And the user selects the "Save Report" button
      		When the user visits the "Maintenance Report" report page
      		Then the user's most recent "Maintenance Report" report should be displayed