@rails-31 @supervisor
Feature: Supervisor Log In
   As a supervisor, I want to sign in and see a welcome message
   Scenario Outline: A supervisor user signs in and sees the correct navbar
   Given the "<organization>" organization exists
   And the "<role>" role exists
   And there exists a user "<user>" whose password is "<password>" with name "<name>"
   And "<user>" fulfills the "<role>" role within the "<organization>" organization
   When the user visits the landing page
   And "<user>" signs in with "<password>"
   Then the welcome message Hi, "<name>" should be displayed
   And the page should display "<nav_option>" menu options containing a "<sub_option>" link
   Examples:
   | user                  | password  |  name         | organization   |  role        | nav_option           | sub_option               |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Students             | Students                 |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Students             | List Students            |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Students             | Search Students          |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Incident Reports     | Incident Reports         |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Incident Reports     | List Incident Reports    |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Incident Reports     | New Incident Reports     |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Maintenance Requests | Maintenance Requests      |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Maintenance Requests | List Maintenance Requests |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Maintenance Requests | New Maintenance Request  |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Notes                | Notes                    |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Notes                | List Notes               |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Notes                | New Note                 |    
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Tasks                | Tasks                    |   
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Tasks                | New Task                 |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Tasks                | List Tasks               |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Shifts/Logs          | Shifts/Logs              |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Shifts/Logs          | Record Shift             |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Shifts/Logs          | My Logs                  |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Shifts/Logs          | List HD Call Logs        |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Shifts/Logs          | List RA Duty Logs        |
   #| supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Manage               | Manage                   |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Manage               | Staff Members            |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Manage               | Buildings                |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Manage               | Areas                    |
   | supervisor@smumn.edu  | password  |  super visor  | Residence Life |  supervisor  | Manage               | Contact Reasons          |
