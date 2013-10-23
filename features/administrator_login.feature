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
   | user                     | password  | name                | organization   | role          | nav_option          | sub_option                                |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Students            | 'menubar_link']['/students']              |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Students            | '/students']                              |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Students            | '/participants/search']                   |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Incident Reports    | 'menubar_link']['/reports?report_type=IncidentReport']    |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Incident Reports    | '/incident_reports/new']                  |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Maintenance Reports | 'menubar_link']['/reports?report_type=MaintenanceReport']    |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Maintenance Reports | '/maintenance_reports/new']               |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Notes               | 'menubar_link']['/reports?report_type=Note']              |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Notes               | '/reports?report_type=Note']              |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Notes               | '/notes/new']                             |    
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Tasks               | 'menubar_link']['/tasks']                 |   
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Tasks               | '/tasks']                                 |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Tasks               | '/tasks/new']                             |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Manage              | 'menubar_link']['/staffs']                                |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Manage              | '/staffs']                                |
   | administrator@smumn.edu  | password  | Radar Administrator | Residence Life | Administrator | Manage              | '/relationship_to_reports']               |