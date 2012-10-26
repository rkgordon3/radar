Feature: sign in
  In order to access the landing page
  As a user of RADAR
  I want to sign in

  Background:
     Given a user "TestUser@smumn.edu" exists as role "HallDirector" in "Residence Life" organization

  Scenario: visit login page
    Given I have visited signin page
    And I have clicked signin link
    Then I am on login page
    And I enter credentials for "TestUser@smumn.edu"
    When I click login
    Then I should be on landing page for "TestUser@smumn.edu"
    And the following selections should be visible
       	|selection|
       	| Students |
       	| Incident Reports |
       	| Maintenance Requests |
	| Notes |
	| Tasks |
	| Shifts/Logs |
	| Manage |
    And there is a submenu "Manage Staff Members"
       

           
