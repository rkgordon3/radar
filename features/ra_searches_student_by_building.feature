@ra_search_student_by_building @rails-31
Feature: RA searches student by building
	As a resident Assistant, I want to search for a students by building
  Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   And the student "Joe" lives in "LaSalle Hall"
  Scenario: A resident Assistant wants to search for a resident by building.
  When the user selects the "Search Students" link
  Then the "Participant Search" message should be displayed
  When the user selects "LaSalle Hall" from the "building_id" menu
  Then the user selects the "Submit" button
  Then the text "Joe Joe" should be displayed