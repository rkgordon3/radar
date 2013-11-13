@ra_search_student_by_building @rails-31 @javascript
Feature: RA searches student by building
	As a resident Assistant, I want to search for a students by building
  Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   And the student "Joe" lives in "LaSalle Hall"
  Scenario: A resident Assistant wants to search for a resident by building.
  When the user visits the "Participants Search" page
  Then the text "Participant Search" should be displayed
  When the user selects "LaSalle Hall" from the "Building" menu
  Then the user selects the "Submit" button
  Then the text "Joe" should be displayed