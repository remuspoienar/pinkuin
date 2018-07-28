Feature: Projects Management

  In order to manage projects
  As a user
  I should be able to perform actions on my projects

  Background:
    Given I am a registered user
    And I am logged in


  Scenario: Listing projects
    Given I have created several projects
    When I visit the homepage
    Then I should see the list of my projects


  Scenario: Creating a new project
    Given I have the right to create projects
    When I visit the homepage
    When I click on the New Project button
    And I fill in the project's details
    Then I should see that my project was created
