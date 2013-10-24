@rails-31
Feature: RA Log In
   As an ra, I want to sign in and see a welcome message
   Scenario Outline: An ra user signs in and sees the correct navbar
   Given the "<organization>" organization exists
   And the "<role>" role exists
   And there exists a user "<user>" whose password is "<password>" with name "<name>"
   And "<user>" fulfills the "<role>" role within the "<organization>" organization
   When the user visits the landing page
   And "<user>" signs in with "<password>"
   Then the welcome message Hi, "<name>" should be displayed
   And the page should display "<nav_option>" menu options containing a "<sub_option>" link
   Examples:
   | user          | password  |  name         | organization   |  role | nav_option           | sub_option                |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Students             | Students                  |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Students             | List Students             |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Students             | Search Students           |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Incident Reports     | Incident Reports          |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Incident Reports     | List Incident Reports     |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Incident Reports     | New Incident Reports      |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Maintenance Requests | Maintenance Requests      |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Maintenance Requests | List Maintenance Requests |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Maintenance Requests | New Maintenance Request   |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Notes                | Notes                     |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Notes                | List Notes                |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Notes                | New Note                  |    
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Tasks                | Tasks                     |   
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Tasks                | New Task                  |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Tasks                | List Tasks                |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Shifts/Logs          | Shifts/Logs               |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Shifts/Logs          | Record Shift              |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Shifts/Logs          | My Logs                   |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Shifts/Logs          | List HD Call Logs         |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Shifts/Logs          | List RA Duty Logs         |
   #| ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Manage               | Manage                    |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Manage               | Staff Members             |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Manage               | Buildings                 |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Manage               | Areas                     |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  ra   | Manage               | Contact Reasons           |