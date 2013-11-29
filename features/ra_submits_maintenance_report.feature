@rails-31 @ra_submits_maintenance_report @javascript @dylan
Feature: RA wants to submit a maintenance report
As a Resident Assistant, I want to be able to submit a maintenance report
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   Scenario: A Resident Assistant user wants to submit a maintenance report.
      When the user visits the New Maintenance Report page
      Then the text "New Maintenance Report" should be displayed
      When the user fills in the "Report Annotation" field with "There's a leak."
      When the user selects the "Submit Report" button