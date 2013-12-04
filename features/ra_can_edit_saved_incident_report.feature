@rails-31 @ra_can_edit_saved_ir @javascript @dylan
Feature: RA can edit saved incident report
As a Resident Assistant, I want to be able to edit a saved incident report
Background:
   Given the user "hd@smumn.edu" is logged in as a "Hall Director"
   And the student "Joe" lives in "LaSalle Hall"
   Scenario: A Hall Director user wants to submit an incident report.
      When the user visits the New Incident Report page
      Then the text "New Incident Report" should be displayed
      When the user fills in the "Report Annotation" field with "Residents were acting crazy."
      And the user selects the "Save Report" button