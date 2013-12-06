@rails-31 @hd_cannot_edit_submitted_ir @reports @javascript @dylan
Feature: HD cannot edit submitted incident report
As a Hall Director, I want to make sure that I cannot edit a submitted incident report
Background:
   Given the user "hd@smumn.edu" is logged in as a "Hall Director"
   And the student "Joe" lives in "LaSalle Hall"
   Scenario: A Hall Director user wants to submit an incident report.
      When the user visits the New Incident Report page
      Then the text "New Incident Report" should be displayed
      When the user fills in the "Report Annotation" field with "Residents were acting crazy."
      And the user selects the "Submit Report" button
      Then the "Incident Report" report should be displayed in the "Recent" section
      And the user should not be able to view the most recent "Incident Report" report