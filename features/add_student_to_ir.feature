@rails-31 @rkg @javascript
Feature: RA wants to add a student to IR
As a Resident Assistant, I want to be able to Add a student to an IR
Background:
   Given the user "ra@smumn.edu" is logged in as a "Resident Assistant"
   And the student "Rob" lives in "LaSalle Hall"
Scenario: Add new student report and confirm FYI (default infraction) is selected
      When the user visits the New Incident Report page
      Then the text "New Incident Report" should be displayed
      And the user fills in the "Full Name" field with "Ro"
      And the user selects "Rob" from the auto-suggestion field
      When the user selects the "Add" button
      Then the student Rob should appear in the report
      When the user expands the infractions list associated with Rob
      Then the FYI infraction should be selected for Rob
