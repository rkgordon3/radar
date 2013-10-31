@rails-31 @ra_list_students
Feature: RA wants to View Student List
   As an ra, I want to see a list of students

Background:
   Given the the user "ra@smumn.edu" is logged in
   And the "ra@smumn.edu" is on the "list students" page
   And the expected students exist

Scenario: An ra navigates to the list students link from the students menu
   Then the text "Student List" should be displayed
   And the "<student>" student should appear "<before_after>" "<before_after_student>" in the student list
   Examples:
   | student   | id | before_after | before_after_student |
   | student C | 2  | Nil          | Nil                  |
   | student B | 3  | after        | student B            |
   | student A | 1  | before       | student B            |