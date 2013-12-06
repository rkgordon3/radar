@rails-31 @hd_manages_note @reports @javascript @dylan
Feature: HD wants to create and manage a note
As a Hall Director, I want to be able to create and manage a note
Background:
   	Given the user "hd@smumn.edu" is logged in as a "Hall Director"
   	When the user visits the New Note page
   	Then the text "New Note" should be displayed
   	When the user fills in the "Report Annotation" field with "Suspicious activity in the plaza."
   		Scenario: A Hall Director user wants to submit a note.
      		When the user selects the "Submit Report" button
      		And the user visits the "Note" report page
      		Then the user's most recent "Note" report should be displayed

   		Scenario: A Hall Director user wants to save a note.
      		And the user selects the "Save Report" button
      		When the user visits the "Note" report page
      		Then the user's most recent "Note" report should be displayed