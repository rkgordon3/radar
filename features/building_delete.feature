@rails-31 @buildings
Feature: System admin deleting buildings
   As a system administrator, I want to be able to delete a building
Background:
   Given the user "radar-admin@smumn.edu" is logged in
   And the user "radar-admin@smumn.edu" is on the manage buildings page
Scenario Outline: A system administrator navigates to manage building link from the manage menu and clicks the Destroy link to remove a building
   Given the user clicks the destroy link on "<building>"
   Then the "<building>" should be removed from the page
   Examples:
   | building              |
   | Radar Test Building A |
   | Radar Test Building B |
   | Radar Test Building C |