@rails-31 @ra_manages_note @reports @javascript @dylan
Feature: RA wants to create and manage a note
As a Resident Assistant, I want to be able to create and manage a note
Background:
   	Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   	When the user visits the New Note page
   	Then the text "New Note" should be displayed
   	When the user fills in the "Report Annotation" field with "Suspicious activity in the plaza."
   		Scenario: A Resident Assistant user wants to submit a note.
      		When the user selects the "Submit Report" button
      		And the user visits the "Note" report page
      		Then the user's most recent "Note" report should be displayed

   		Scenario: A Resident Assistant user wants to save a note.
      		And the user selects the "Save Report" button
      		When the user visits the "Note" report page
      		Then the user's most recent "Note" report should be displayed