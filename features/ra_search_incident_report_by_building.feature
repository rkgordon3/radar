@rails-31 @ra_search_incident_report_by_building @javascript
Feature: RA wants to search Incident Reports by building
As a Resident Assistant, I want to be able to search incident reports by building name
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   And the building named LaSalle Hall exists
   And the building named Heffron Hall exists
   And an "Incident Report" submitted by "ra@smumn.edu" exists for building "LaSalle Hall"
   And an "Incident Report" submitted by "ra@smumn.edu" exists for building "Heffron Hall"
   Scenario: A Resident Assistant user is on duty and wants to search for an incident report by building name
      When the user visits the "Incident Report" report page
      Then the text "Report Search" should be displayed
      And the "Incident Report" report for "LaSalle Hall" should be displayed
      And the "Incident Report" report for "Heffron Hall" should be displayed
      When the user selects "LaSalle Hall" from the "Building" menu
      And the user selects the "Update" button
      Then the "Incident Report" report for "LaSalle Hall" should be displayed
      And the "Incident Report" report for "Heffron Hall" should not be displayed