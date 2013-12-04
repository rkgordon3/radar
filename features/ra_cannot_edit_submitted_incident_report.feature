@rails-31 @ra_cannot_edit_submitted_ir @javascript @dylan
Feature: RA cannot edit submitted incident report
As a Resident Assistant, I want to make sure that I cannot edit a submitted incident report
Background:
   Given the user "hd@smumn.edu" is logged in as a "Hall Director"
   And the student "Joe" lives in "LaSalle Hall"
   Scenario: A Hall Director user wants to submit an incident report.
      When the user visits the New Incident Report page
      Then the text "New Incident Report" should be displayed
      When the user fills in the "Report Annotation" field with "Residents were acting crazy."
      And the user selects the "Submit Report" button