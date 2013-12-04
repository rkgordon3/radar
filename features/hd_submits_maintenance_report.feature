@rails-31 @hd_submits_mr @javascript @dylan
Feature: HD wants to submit a maintenance report
As a Hall Director, I want to be able to submit a maintenance report
Background:
   Given the user "hd@smumn.edu" is logged in as a "Hall Director"
   Scenario: A Hall Director user wants to submit a maintenance report.
      When the user visits the New Maintenance Report page
      Then the text "New Maintenance Report" should be displayed
      When the user fills in the "Report Annotation" field with "There's a leak."
      And the user selects the "Submit Report" button