@rails-31
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
   | user                       | password  | name            | organization   | role            | nav_option          | sub_option                                |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Students            | 'menubar_link]'['/students']                |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Students            | '/students']                              |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Students            | '/participants/search']                   |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Incident Reports    | 'menubar_link']['/reports?report_type=IncidentReport']    |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Incident Reports    | '/reports?report_type=IncidentReport']    |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Incident Reports    | '/incident_reports/new']                  |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Maintenance Reports | 'menubar_link']['/reports?report_type=MaintenanceReport'] |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Maintenance Reports | '/reports?report_type=MaintenanceReport'] |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Maintenance Reports | '/maintenance_reports/new']               |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Notes               | 'menubar_link']['/reports?report_type=Note']              |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Notes               | '/reports?report_type=Note']              |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Notes               | '/notes/new']                             |    
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Tasks               | 'menubar_link']['/tasks']                 |  
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Tasks               | '/tasks']                                 |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Tasks               | '/tasks/new']                             |
   | admin-assistant@smumn.edu  | password  | Admin Assistant | Residence Life | Admin Assistant | Manage              | '/staffs']                                |