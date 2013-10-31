@rails-31 @buildings
Feature: System admin deleting buildings
   As a system administrator, I want to be able to delete a building
   Scenario Outline: A system administrator navigates to manage building link from the manage menu and clicks the Destroy link to remove a building
   Given the "<organization>" organization exists
   And the "<role>" role exists
   And there exists a user "<user>" whose password is "<password>" with name "<name>"
   And "<user>" fulfills the "<role>" role within the "<organization>" organization
   When the user visits the landing page
   And "<user>" signs in with "<password>"
   When the user visits the manage buildings page
   And the user clicks the destroy link on "<building>"
   Then the "<building>" should be removed from the page
   Examples:
   | user                     | password  | organization   | role                 | building               | abbreviation | area          |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building A  | rtba         | Unspecified   |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building B  | rtbb         | Unspecified   |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building C  | rtbc         | Unspecified   |