Feature: Authentication

  In order to use the application
  As a user
  I should be able to sign up, log in and log out

  Scenario: Signing up
    Given I visit the homepage
    When I fill in the sign up form
    And I open the email with subject "Confirmation instructions"
    Then I should see the email delivered from "Pinkuin app <app@pinkuin.club>"
    When I follow "Confirm my account" in the email
    Then I should see that my account is confirmed


  Scenario: Logging in
    Given I am a registered user
    And I visit the homepage
    When I fill in the login form
    Then I should be logged in


  Scenario: Logging out
    Given I am a registered user
    And I am logged in
    And I visit the homepage
    When I click on the Log out button
    Then I should be redirected to the log in page