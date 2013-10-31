@rails-31 @buildings
Feature: System admin adding buildings
   As a system administrator, I want to be able to add a building
   Scenario Outline: A system administrator navigates to manage building link from the manage menu and clicks the New Building link and fills in the form to create a new building
   Given the "<organization>" organization exists
   And the "<role>" role exists
   And there exists a user "<user>" whose password is "<password>" with name "<name>"
   And "<user>" fulfills the "<role>" role within the "<organization>" organization
   When the user visits the landing page
   And "<user>" signs in with "<password>"
   When the user visits the manage buildings page
   And the user clicks the New Building links
   And the user fills in "building_name" with "<building>"
   And the user fills in "building_abbreviation" with "abbreviation"
   And the user selects "building_area_id" with "<area>"
   And the user clicks the create button
   Then the "<building>" should appear "<before_after>" "<before_after_building>" in the building list
   Examples:
   | user                     | password  | organization   | role                 | building               | abbreviation | area                  | before_after | before_after_building |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building B  | rtbb         | Unspecified           | Nil          | Nil                   |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building C  | rtbc         | Watters, Ek Village   | after        | Radar Test Building B |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building A  | rtba         | LaSalle               | before       | Radar Test Building B |