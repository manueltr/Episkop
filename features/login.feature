Feature: logging into account

    As a user using the site
    So that I can make a poll
    I want to login to my account

Scenario: login is successful

    Given I am on the home page
    When I press the Google button
    And the Google authentication is successful
    Then I should see "Successful login"
    And I am navigated to Account page

Scenario: login fails

    Given I am on the home page
    When I press the Google button
    And the Google authentication fails
    Then I should see "Invalid login"
    And I am navigated to Account page
