@rails-31 @ra_saves_note @javascript @dylan
Feature: RA wants to save a note
As a Resident Assistant, I want to be able to save a note
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   Scenario: A Resident Assistant user wants to save a note
      When the user visits the New Note page
      Then the text "New Note" should be displayed
      When the user fills in the "Note Annotation" field with "Suspicious activity in the plaza."
      When the user selects the "Save Note" button