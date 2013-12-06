@rails-31 @hd_saves_ir @reports @javascript @dylan
Feature: HD wants to save an incident report
As a Hall Director, I want to be able to save an incident report
Background:
   Given the user "hd@smumn.edu" is logged in as a "Hall Director"
   Scenario: A Hall Director user wants to save an incident report.
      When the user visits the New Incident Report page
      Then the text "New Incident Report" should be displayed
      When the user fills in the "Report Annotation" field with "Residents were acting crazy."
      And the user selects the "Save Report" button
      Then the "Incident Report" report should be displayed in the "Unsubmitted" section