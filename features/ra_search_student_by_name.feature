@rails-31 @ra_search_student_by_name
Feature: RA wants to search student by name
As a Resident Assistant, I want to be able to search students by name
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   And the student "Joe" lives in "LaSalle Hall"
   Scenario: A Resident Assistant user is on duty and wants to search for a student by name
      When the user visits the "Participants Search" page
      Then the "Participant Search" message should be displayed
      And the user fills in the "full_name" field with "Joe"
      And the user selects from the auto-suggestion field
      When the user selects the "Submit" button
      And the text "Joe Joe" should be displayed
