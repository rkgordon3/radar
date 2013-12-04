@rails-31 @hd_submits_note @javascript @dylan
Feature: HD wants to submit a note
As a Hall Director, I want to be able to submit a note
Background:
   Given the user "hd@smumn.edu" is logged in as a "Hall Director"
   Scenario: A Hall Director user wants to submit a note.
      When the user visits the New Note page
      Then the text "New Note" should be displayed
      When the user fills in the "Note Annotation" field with "Suspicious activity in the plaza."
      And the user selects the "Submit Note" button