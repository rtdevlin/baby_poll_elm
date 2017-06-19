@accounts @javascript
Feature: Account

  Scenario: Reaching the sign up page
    Given a user reaches the homepage
    When a user clicks Sign Up
    Then the user should reach the sign up page

  Scenario: Creating a new user
    Given a user reaches the sign up page
    When the user enters a valid username and password
    Then a new user should be created
    And the user should be redirected to the homepage and logged in

  Scenario: User already exists
    Given a user reaches the sign up page
    When the user tries to create an existing account
    Then an error message should be displayed

  Scenario: Reaching the log in page
    Given a user reaches the homepage
    When a user clicks Log In
    Then the user should reach the log in page

  Scenario: Valid Log In
    Given a user reaches the log in page
    When the user enters a valid username and password
    Then the user should be redirected to the homepage and logged in

  Scenario: Invalid Log In
    Given a user reaches the log in page
    When the user enters a invalid username and password
    Then an error message should be displayed
