@rails-31 @ra_list_students_building @David
Feature: RA wants to View Student List by Building
   As an ra, I want to see a list of students by building

Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   And the student "Joe" lives in "LaSalle Hall"
   And the student "Mary" lives in "Ek Family Village"

Scenario: An ra navigates to the list students link from the students menu
   When the "ra@smumn.edu" is on the list "students" page
   Then the text "Student List" should be displayed
   And I should see the students in this order:
   | Joe  |
   | Mary |

   And the user selects the "Building" link
   Then the students are listed by building in this order:
   | Ek Family Village |
   | LaSalle Hall      |