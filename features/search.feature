@search
Feature: search
  A user wants to search reports

  Background:
     Given a user "TestUser@smumn.edu" with password "password" exists as role "HallDirector" in "Residence Life" organization
     And "TestUser@smumn.edu" is logged in with password "password"

  Scenario: visit search
	And User is viewing page entitled "Unsubmitted Reports"
        And User follows link "List Incident Report"
	And User is viewing page entitled "Report Search"

