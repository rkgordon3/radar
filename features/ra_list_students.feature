@rails-31 @ra_list_students
Feature: RA wants to View Student List
	As an ra, I want to see a list of students

Background:
	Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
	And the student "Joe" lives in "LaSalle Hall"
	And the student "Mary" lives in "Ek Family Village"

Scenario: An ra navigates to the list students link from the students menu
	And the "ra@smumn.edu" is on the list "students" page
	Then the text "Student List" should be displayed
	And I should see the students in this order:
	| Joe  |
	| Mary |
