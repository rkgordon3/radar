@rails-31 @ra_list_students_building
Feature: RA wants to View Student List by Building
   As an ra, I want to see a list of students by building

Background:
   Given the user "ra@smumn.edu" is logged in
   And the "ra@smumn.edu" is on the "list students" page
   And the expected students exist

Scenario: An ra user signs in and sees the correct navbar
   Then the text "Student List" should be displayed
   And the "<student>" student should appear "<before_after>" "<before_after_student>" in the student list
   And the user selects the "building" link
   Then the students are listed by building
   Examples:
   | student   | id | before_after | before_after_student |
   | student C | 2  | Nil          | Nil                  |
   | student B | 3  | after        | student B            |
   | student A | 1  | before       | student B            |