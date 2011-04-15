Feature: submit an incident report
	In order to document an invent
	As a logged in user of RADAR
	I want to submit an incident report


	Scenario: submit an incident report
		Given I am a logged in user of RADAR
		When I sumbit an incident report
		Then I should see the incident report in the database