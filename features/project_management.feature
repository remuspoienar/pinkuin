Feature: Project Management

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
    And I click on the New Project button
    And I fill in the project's details
    And I click on the create button
    Then I should see that my project was saved


  Scenario: Updating the details of a project
    Given I have previously created a project
    When I go to the project's page
    And I click on the Edit button
    And I fill in the project's details
    And I click on the update button
    Then I should see that my project was saved


  @javascript
  Scenario: Deleting a project
    Given I have previously created a project
    When I go to the project's page
    And I click the delete button and confirm
    Then I should not see it in the projects list anymore
