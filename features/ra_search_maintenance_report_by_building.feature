@rails-31 @ra_search_mr_by_building @javascript @dylan @ra_search_report_building
Feature: RA wants to search Maintenance Reports by building
As a Resident Assistant, I want to be able to search maintenance reports by building name
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   And the building named LaSalle Hall exists
   And the building named Heffron Hall exists
   And a "Maintenance Report" submitted by "ra@smumn.edu" exists for building "LaSalle Hall"
   And a "Maintenance Report" submitted by "ra@smumn.edu" exists for building "Heffron Hall"
   Scenario: A Resident Assistant user is on duty and wants to search for a maintenance report by building name
      When the user visits the "Maintenance Report" report page
      Then the text "Report Search" should be displayed
      And the "Maintenance Report" report for "LaSalle Hall" should be displayed
      And the "Maintenance Report" report for "Heffron Hall" should be displayed
      When the user selects "LaSalle Hall" from the "Building" menu
      And the user selects the "Update" button
      Then the results should contain 1 report from LaSalle Hall
      And the results should contain 0 reports from Heffron Hall

