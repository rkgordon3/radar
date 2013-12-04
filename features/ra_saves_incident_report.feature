@rails-31 @ra_saves_ir @javascript @dylan
Feature: RA wants to save an incident report
As a Resident Assistant, I want to be able to save an incident report
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   Scenario: A Resident Assistant user wants to save an incident report.
      When the user visits the New Incident Report page
      Then the text "New Incident Report" should be displayed
      When the user fills in the "Report Annotation" field with "Residents were acting crazy."
      And the user selects the "Save Report" button