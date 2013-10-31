@rails-31 @ra_list_students
Feature: RA wants to View Student List
   As an ra, I want to see a list of students

Background:
   Given the the user "ra@smumn.edu" is logged in
   And the "ra@smumn.edu" is on the list "students" page
   And the student "Joe" exists
   And the student "Mary" exits

Scenario: An ra navigates to the list students link from the students menu
   Then the text "Student List" should be displayed
   And the students should appear in "alphabetical" order by last name