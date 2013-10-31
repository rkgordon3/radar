@rails-31 @buildings
Feature: System admin editing buildings
   As a system administrator, I want to be able to edit a building
   Scenario Outline: A system administrator navigates to manage building link from the manage menu and clicks the Edit link to edit a building
   Given the "<organization>" organization exists
   And the "<role>" role exists
   And there exists a user "<user>" whose password is "<password>" with name "<name>"
   And "<user>" fulfills the "<role>" role within the "<organization>" organization
   When the user visits the landing page
   And "<user>" signs in with "<password>"
   When the user visits the manage buildings page
   And the user clicks the edit link on "<building>"
   And the user changes the name of "<building>" to "<new_building>"
   And the user changes the name of "<abbreviation>" to "<new_abbreviation>"
   And the user changes the area selection for "<building>" to "<new_area>"
   And the user clicks the Save button
   Then the "<building>" should be updated to "<new_building>" along with its edits: "<new_abbreviation>" and "<new_area>"
   Examples:
   | user                     | password  | organization   | role                 | building               | abbreviation | area          | new_building     | new_abbreviation | new_area                                    |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building A  | rtba         | Unspecified   | Crazy Building X | cbx              | Brother Leopold, Residencia Santiago Miller |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building B  | rtbb         | Unspecified   | Crazy Building Y | cby              | St. Edwards                                 |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building C  | rtbc         | Unspecified   | Crazy Building Z | cbz              | Unspecified                                 |