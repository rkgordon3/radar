@rails-31 @hd @gabe
Feature: System Admin Log In
   As a Hall Director member, I want to sign in and see a welcome message
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
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Students             | List Students             |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Students             | Students                  | 
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Students             | Search Students           |   
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Manage               | Manage                    |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Manage               | Staff Members             |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Manage               | Contact Reasons           |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Manage               | Buildings                 |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Manage               | Areas                     |   
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Incident Reports     | Incident Reports          |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Incident Reports     | List Incident Reports     |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Incident Reports     | New Incident Reports      |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Maintenance Requests | Maintenance Requests      |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Maintenance Requests | New Maintenance Requests  | 
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Maintenance Requests | List Maintenance Requests |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Notes                | Notes                     |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Notes                | List Notes                |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Notes                | New Notes                 |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Tasks                | Tasks                     |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Tasks                | New Tasks                 |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Tasks                | List Tasks                | 
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Shifts/Logs          | Shifts/Logs               | 
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Shifts/Logs          | Record Shift              |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Shifts/Logs          | My Logs                   | 
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Shifts/Logs          | List HD Call Logs         |
   | hall-director@smumn.edu  | password  | Hall Director | Residence Life | Hall Director | Shifts/Logs          | List RA Duty Logs         |   
