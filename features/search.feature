@search
Feature: search
  A user wants to search reports

  Background:
     Given a user "TestUser@smumn.edu" with password "password" exists as role "HallDirector" in "Residence Life" organization
     And "TestUser@smumn.edu" with is logged in with password "password" and viewing landing page

  Scenario: visit search
        And I follow link "List Incident Report"
	And I am viewing page entitled "Report Search"

