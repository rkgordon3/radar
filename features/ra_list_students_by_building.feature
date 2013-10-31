@rails-31 @ra_list_students_building
Feature: RA wants to View Student List by Building
   As an ra, I want to see a list of students by building

Background:
   Given the user "ra@smumn.edu" is logged in
   And the "ra@smumn.edu" is on the "list students" page
   And the student "Joe" exists
   And the student "Mary" exits

Scenario: An ra user signs in and sees the correct navbar
   Then the text "Student List" should be displayed
   And the students should appear in "alphabetical" order by last name
   And the user selects the "building" link
   Then the students are listed by building