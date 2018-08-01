Feature: User Management

  In order to manage users
  As an user administrator
  I should be able to view, add, update and delete users


  Background:
    Given I am a registered user
    And I have the general role to administrate users
    And I am logged in


  @create_users
  Scenario: Listing users
    When I click on the User Administration button
    Then I should see the list of registered users


  Scenario: Creating a new user
    Given I have the right to create users
    And I visit the User Administration page
    And I click on the New User button
    And I fill in the user's details
    And I click on the create button
    Then I should see that the user was created


  Scenario: Updating the details of an user
    Given I have previously created an user
    When I go to that user's page
    And I click on the Edit button
    And I fill in the user's details
    And I click on the update button
    Then I should see that the user was updated


  @javascript
  Scenario: Deleting an user
    Given I have previously created an user
    When I go to that user's page
    And I click the delete button and confirm
    Then I should not see it in the users list anymore

