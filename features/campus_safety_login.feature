@rails-31
Feature: System Admin Log In
   As a campus safety member, I want to sign in and see a welcome message
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
   | user                     | password  | name          | organization   | role          | nav_option           | sub_option                |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Students             | List Students             |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Students             | Students                  |   
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Manage               | Manage                    |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Manage               | Staff Members             |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Incident Reports     | Incident Reports          |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Incident Reports     | List Incident Reports     |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Incident Reports     | New Incident Reports      |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Maintenance Requests | Maintenance Requests      |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Maintenance Requests | List Maintenance Requests |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Notes                | Notes                     |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Notes                | List Notes                |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Notes                | New Notes                 |
   | campus-safety@smumn.edu  | password  | Campus Safety | Residence Life | Campus Safety | Tasks                | Tasks                     |
