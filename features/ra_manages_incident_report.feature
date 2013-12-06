@rails-31 @ra_manages_ir @reports @javascript @dylan
Feature: RA wants to create and manage an incident report
As a Resident Assistant, I want to be able to create and manage an incident report
Background:
   	Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   	When the user visits the New Incident Report page
   	Then the text "New Incident Report" should be displayed
   	When the user fills in the "Report Annotation" field with "Residents were acting crazy."
   		Scenario: A Resident Assistant user wants to submit an incident report.
      		And the user selects the "Submit Report" button    
      		Then the user's most recent "Incident Report" report should be displayed in the "Recent" section 

   		Scenario: A Resident Assistant user wants to save an incident report.
      		And the user selects the "Save Report" button
      		Then the user's most recent "Incident Report" report should be displayed in the "Unsubmitted" section

      	Scenario: A Resident Assistant user wants to view and edit a saved incident report.
      		And the user selects the "Save Report" button
      		Then the user's most recent "Incident Report" report should be displayed in the "Unsubmitted" section
      		When the user visits the show page for their most recent "Incident Report" report
      		And an "Edit" link should be displayed
	  		When the user selects the "Edit" link
      		Then the text "Editing Incident Report" should be displayed

      	Scenario: A Resident Assistant user wants to view a submitted incident report but cannot.
      		And the user selects the "Submit Report" button
      		Then the user's most recent "Incident Report" report should be displayed in the "Recent" section
      		And the user should not be able to view their most recent "Incident Report" report