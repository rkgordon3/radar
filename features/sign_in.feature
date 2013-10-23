@sign-in
Feature: sign in
  In order to access the landing page
  As a user of RADAR
  I want to sign in

  Background:
     Given a user "TestUser@smumn.edu" with password "password" exists as role "HallDirector" in "Residence Life" organization
     And "TestUser@smumn.edu" is logged in with password "password"
  Scenario: visit login page
    And  User is viewing page entitled "Unsubmitted Reports"
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
       

           
