Feature: sign in
	In order to access the landing page
	As a user of RADAR
	I want to sign in


	Scenario: sign in
		Given I am a user of RADAR
		When I sign in
		Then I should be directed to the landing page