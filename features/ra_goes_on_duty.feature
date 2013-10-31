@ra_duty
Feature: RA Goes on Duty
	As a Resident Assistant member, I want to go on duty and see the red clickable icon and message to end my shift and the notification confirming I am on duty.
	Scenario Outline: A Resident Assistant goes on duty and sees the correct message and end shift icon and message.
    Given the "<organization>" organization exists
    And the "<role>" role exists
    And there exists a user "<user>" whose password is "<password>" with name "<name>"
    And "<user>" fulfills the "<role>" role within the "<organization>" organization
    When the user visits the landing page
    And "<user>" signs in with "<password>"
    Then the welcome message Hi, "<name>" should be displayed
    And the page should display "<nav_option>" menu options containing a "<sub_option>" link
 	And the green GO icon should appear and the Go on Duty option should be visible
	When the "<user>" selects go on duty
	Then the "<user>" should be on duty
	And the message "You are now on duty" appears
	Then the page should display the red STOP icon and the Go Off Duty and Go on Round options should be visible
	Examples:
   | user          | password  |  name         | organization   |  role                 | nav_option           | sub_option                |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Students             | Students                  |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Students             | List Students             |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Students             | Search Students           |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Incident Reports     | Incident Reports          |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Incident Reports     | List Incident Reports     |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Incident Reports     | New Incident Report       |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Maintenance Requests | Maintenance Requests      |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Maintenance Requests | List Maintenance Requests |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Maintenance Requests | New Maintenance Request   |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Notes                | Notes                     |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Notes                | List Notes                |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Notes                | New Note                  |    
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Tasks                | Tasks                     |   
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Tasks                | My To Do List             |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Shifts/Logs          | Shifts/Logs               |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Shifts/Logs          | My Logs                   |
   #| ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Manage               | Manage                    |
   | ra@smumn.edu  | password  |  ra reslife   | Residence Life |  Resident Assistant   | Manage               | Staff Members             |