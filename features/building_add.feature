@rails-31 @buildings
Feature: System admin adding buildings
As a system administrator, I want to be able to add a building
Background:
   Given the user "radar-admin@smumn.edu" is logged in
   And the user "radar-admin@smumn.edu" is on the manage buildings page
Scenario Outline: A system administrator navigates to manage building link from the manage menu and wants to add new buildings
   When the user visits the manage buildings page
   And the user clicks the New Building link
   And the user fills in "building_name" with "<building>"
   And the user fills in "building_abbreviation" with "abbreviation"
   And the user selects "building_area_id" with "<area>"
   And the user clicks the create button
   Then the "<building>" building should appear "<before_after>" "<before_after_building>" in the building list
   Examples:
   | user                     | password  | organization   | role                 | building               | abbreviation | area                  | before_after | before_after_building |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building B  | rtbb         | Unspecified           | Nil          | Nil                   |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building C  | rtbc         | Watters, Ek Village   | after        | Radar Test Building B |
   | radar-admin@smumn.edu    | password  | Residence Life | System Administrator | Radar Test Building A  | rtba         | LaSalle               | before       | Radar Test Building B |