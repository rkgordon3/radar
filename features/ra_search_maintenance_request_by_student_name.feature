@rails-31 @ra_search_mr_by_student_name @javascript @dylan
Feature: RA wants to search Maintenance Requests by student name
As a Resident Assistant, I want to be able to search maintenance requests by students name
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   And the student "Joe" lives in "LaSalle Hall"
   And an "Maintenance Report" exists for student "Joe"
   Scenario: A Resident Assistant user is on duty and wants to search for a student by name
      When the user visits the "Maintenance Report" report page
      Then the text "Report Search" should be displayed
      And the user fills in the "full_name" field with "Jo"
      And the user selects "Joe" from the auto-suggestion field
      When the user selects the "Update" button
      And the text "Joe" should be displayed