@authority
Feature: Proper authorities at login
Scenario:
	Given the "Residence Life" organization exists
        And the "Staff" role exists
        And the user "joe" exists with password "pw" 
        #And "Joe" fulfills the "Staff" role within the "Residence Life" organization
        And "Joe" fulfills the "current" role within the "current" organization
