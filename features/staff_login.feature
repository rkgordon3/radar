@rails-31
Feature: System Admin Log In
   As a Staff Guy member, I want to sign in and see a welcome message
   Scenario Outline: A system admin user signs in and sees the correct navbar
   Given the "<organization>" organization exists
   And the "<role>" role exists
   And there exists a user "<user>" whose password is "<password>" with name "<name>"
   And "<user>" fulfills the "<role>" role within the "<organization>" organization
   When the user visits the landing page
   And "<user>" signs in with "<password>"
   Then the welcome message Hi, "<name>" should be displayed
   And the page should display "<nav_option>" menu options containing a "<sub_option>" link
   Examples:
   | user             | password  | name      | organization   | role      | nav_option           | sub_option                |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Students             | List Students             |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Students             | Students                  | 
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Students             | Search Students           |   
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Manage               | Manage                    |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Manage               | Staff Members             |  
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Incident Reports     | Incident Reports          |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Incident Reports     | List Incident Reports     |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Incident Reports     | New Incident Reports      |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Maintenance Requests | Maintenance Requests      |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Maintenance Requests | New Maintenance Requests  | 
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Maintenance Requests | List Maintenance Requests |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Notes                | Notes                     |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Notes                | List Notes                |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Notes                | New Notes                 |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Tasks                | Tasks                     |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Tasks                | My To Do List             |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Shifts/Logs          | Shifts/Logs               |
   | staff@smumn.edu  | password  | Staff Guy | Residence Life | Staff     | Shifts/Logs          | My Logs                   |
   
