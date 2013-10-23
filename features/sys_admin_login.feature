@rails-31
Feature: System Admin Log In
   As a system admin, I want to sign in and see a welcome message
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
   | user                   | password  | name       | organization   | role                 | nav_option | sub_option                 |
   | radar-admin@smumn.edu  | password  | Super User | Residence Life | System Administrator | Search     | 'menubar_link']['/participants/search'] |
   | radar-admin@smumn.edu  | password  | Super User | Residence Life | System Administrator | Search     | '/participants/search']    |
   | radar-admin@smumn.edu  | password  | Super User | Residence Life | System Administrator | Search     | '/reports']                |
   | radar-admin@smumn.edu  | password  | Super User | Residence Life | System Administrator | Manage     | 'menubar_link']['/staffs'] |
   | radar-admin@smumn.edu  | password  | Super User | Residence Life | System Administrator | Manage     | '/staffs']                 |
   | radar-admin@smumn.edu  | password  | Super User | Residence Life | System Administrator | Manage     | '/buildings']              |
   | radar-admin@smumn.edu  | password  | Super User | Residence Life | System Administrator | Manage     | '/areas']                  |
   | radar-admin@smumn.edu  | password  | Super User | Residence Life | System Administrator | Manage     | '/tasks']                  |
   | radar-admin@smumn.edu  | password  | Super User | Residence Life | System Administrator | Manage     | '/relationship_to_reports']|