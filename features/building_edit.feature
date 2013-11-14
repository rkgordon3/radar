@rails-31 @buildings_edit @buildings
Feature: System admin editing buildings
   As a system administrator, I want to be able to edit a building
Background:
   Given the user "radar-admin@smumn.edu" is logged in as a "System Administrator"
    When the user visits the "Manage Buildings" page
Scenario Outline: A system administrator navigates to manage building link from the manage menu and clicks the Edit link to edit a building
   Given the user clicks the edit link on "<building>"
   And the user changes the name of "<building>" to "<new_building>"
   And the user changes the abbreviation from "<abbreviation>" to "<new_abbreviation>"
   And the user changes the area selection from "<area>" to "<new_area>"
   And the user clicks the Save button
   Then the "<building>" building should be updated to "<new_building>" along with its new abbrevation: "<new_abbreviation>" and its new area: "<new_area>"
   Examples:
   | building               | abbreviation | area          | new_building     | new_abbreviation | new_area                                    |
   | Radar Test Building A  | rtba         | Unspecified   | Crazy Building X | cbx              | Brother Leopold, Residencia Santiago Miller |
   | Radar Test Building B  | rtbb         | Unspecified   | Crazy Building Y | cby              | St. Edwards                                 |
   | Radar Test Building C  | rtbc         | Unspecified   | Crazy Building Z | cbz              | Unspecified                                 |