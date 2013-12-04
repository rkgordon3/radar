@rails-31 @ra_submits_ir @javascript @dylan
Feature: RA wants to submit an incident report
As a Resident Assistant, I want to be able to submit an incident report
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   Scenario: A Resident Assistant user wants to submit an incident report.
      When the user visits the New Incident Report page
      Then the text "New Incident Report" should be displayed
      When the user fills in the "Report Annotation" field with "Residents were acting crazy."
      And the user selects the "Submit Report" button      