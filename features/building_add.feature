@rails-31 @buildings
Feature: System admin adding buildings
As a system administrator, I want to be able to add a building
Background:
   Given the user "radar-admin@smumn.edu" is logged in
   And the user "radar-admin@smumn.edu" is on the manage "<buildings>" page
Scenario Outline: A system administrator navigates to manage building link from the manage menu and wants to add new buildings
   When the user selects the "New Building" link
   And the user fills in the "Name" field with "<building>"
   And the user fills in the "Abbreviation" field with "<abbreviation>"
   And the user selects "<area>" from the "Area" menu
   And the user selects the "Create" button
   Then the "<building>" list should appear in "alphabetical" order
   Examples:
   | building               | abbreviation | area                  |
   | Radar Test Building B  | rtbb         | Unspecified           |
   | Radar Test Building C  | rtbc         | Watters, Ek Village   |
   | Radar Test Building A  | rtba         | LaSalle               |