@rails-31 @hd_saves_maintenance_report @javascript @dylan
Feature: HD wants to save a maintenance report
As a Hall Director, I want to be able to save a maintenance report
Background:
   Given the user "hd@smumn.edu" is logged in as a "Hall Director"
   Scenario: A Hall Director user wants to save a maintenance report.
      When the user visits the New Maintenance Report page
      Then the text "New Maintenance Report" should be displayed
      When the user fills in the "Report Annotation" field with "There's a leak."
      When the user selects the "Save Report" button