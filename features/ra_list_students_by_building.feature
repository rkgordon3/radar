@rails-31 @ra_list_students_building
Feature: RA wants to View Student List by Building
   As an ra, I want to see a list of students by building

   Scenario Outline: An ra user signs in and sees the correct navbar
   Given the "<organization>" organization exists
   And the expected students exist
   And the expected buildings exist
   And the "<role>" role exists
   And there exists a user "<user>" whose password is "<password>" with name "<name>"
   And "<user>" fulfills the "<role>" role within the "<organization>" organization
   When the user visits the landing page
   And "<user>" signs in with "<password>"
   Then the welcome message Hi, "<name>" should be displayed
   And the page should display "<nav_option>" menu options containing a "<sub_option>" link
   When the user visits the list students page
   Then the text "Student List" should be displayed
   And the students are listed by last name
   And the user clicks on a building
   Then the students are listed by building
   Examples:
   | user          | password  |  name         | organization   |  role                 | nav_option           | sub_option                |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Students             | Students                  |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Students             | List Students             |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Students             | Search Students           |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Incident Reports     | Incident Reports          |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Incident Reports     | List Incident Reports     |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Incident Reports     | New Incident Report       |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Maintenance Requests | Maintenance Requests      |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Maintenance Requests | List Maintenance Requests |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Maintenance Requests | New Maintenance Request   |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Notes                | Notes                     |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Notes                | List Notes                |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Notes                | New Note                  |    
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Tasks                | Tasks                     |   
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Tasks                | My To Do List             |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Shifts/Logs          | Shifts/Logs               |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Shifts/Logs          | My Logs                   |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Manage               | Staff Members             |