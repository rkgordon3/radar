@rails-31 @admin-assistant @dylan
Feature: Admin Assistant Log In
   As an admin assistant, I want to sign in and see a welcome message
   Scenario Outline: An admin assistant user signs in and sees the correct navbar
   Given the "<organization>" organization exists
   And the "<role>" role exists
   And there exists a user "<user>" whose password is "<password>" with name "<name>"
   And "<user>" fulfills the "<role>" role within the "<organization>" organization
   When the user visits the landing page
   And "<user>" signs in with "<password>"
   Then the welcome message Hi, "<name>" should be displayed
   And the page should display "<nav_option>" menu options containing a "<sub_option>" link
   Examples:
   | user                       | password  | name            | organization   | role                     | nav_option          | sub_option               |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Students            | Students                 |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Students            | List Students            |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Students            | Search Students          |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Incident Reports    | Incident Reports         |    
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Incident Reports    | List Incident Reports    |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Incident Reports    | New Incident Report      |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Maintenance Requests| Maintenance Requests     |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Maintenance Requests| List Maintenance Requests|
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Maintenance Requests| New Maintenance Request  |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Notes               | Notes                    |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Notes               | List Notes               |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Notes               | New Note                 |    
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Tasks               | Tasks                    |  
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Tasks               | List Tasks               |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Tasks               | New Task                 |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Administrative Assistant | Manage              | Staff Members            |
