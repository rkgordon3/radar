@rails-31
Feature: Administrator Log In
   As an administrator, I want to sign in and see a welcome message
   Scenario Outline: An administrator user signs in and sees the correct navbar
   Given the "<organization>" organization exists
   And the "<role>" role exists
   And there exists a user "<user>" whose password is "<password>" with name "<name>"
   And "<user>" fulfills the "<role>" role within the "<organization>" organization
   When the user visits the landing page
   And "<user>" signs in with "<password>"
   Then the welcome message Hi, "<name>" should be displayed
   And the page should display "<nav_option>" menu options containing a "<sub_option>" link
   Examples:
   | user                     | password  | name                | organization   | role          | nav_option          | sub_option               |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Students            | Students                 |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Students            | List Students            |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Students            | Search Students          |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Incident Reports    | Incident Reports         |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Incident Reports    | List Incident Reports    |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Incident Reports    | New Incident Reports     |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Maintenance Requests| Maintenance Requests     |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Maintenance Requests| List Maintenance Requests|
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Maintenance Requests| New Maintenance Requests |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Notes               | Notes                    |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Notes               | List Notes               |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Notes               | New Notes                |    
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Tasks               | Tasks                    |   
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Tasks               | New Tasks                |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Tasks               | List Tasks               |
   #| administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Manage              | Manage                   |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Manage              | Staff Members            |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Manage              | Contact Reasons          |