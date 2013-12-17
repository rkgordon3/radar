@rails-31 @ra_search_student_by_name @javascript @dylan @fail
Feature: RA wants to search student by name
As a Resident Assistant, I want to be able to search students by name
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   And the student "Joe" lives in "LaSalle Hall"
   Scenario: A Resident Assistant user is on duty and wants to search for a student by name
      When the user visits the "Participants Search" page
      Then the text "Participant Search" should be displayed
      And the user fills in the "Full Name" field with "Jo"
      And the user selects "Joe" from the auto-suggestion field
      When the user selects the "Submit" button
      And the text "Joe" should be displayed
      And the student with name Joe should exist
