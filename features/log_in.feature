@rails-31
Feature: Log In
   As a super user, I want to sign in and see a welcome message
   Scenario Outline: A user signs in
	 Given there exists a user "<user>" whose password is "<password>" with name "<name>"
	 When I visit the landing page
	 And a user "<user>" signs in with "<password>"
	 Then I should see a Hi, "<name>" message
	 Examples:
	 | user       			  | password      | name       |
	 | radar-admin@smumn.edu  | password      | Super User |

