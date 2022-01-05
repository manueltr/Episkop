Feature: logging into account

    As a user using the site
    So that I can make a poll
    I want to login to my account

Scenario: login is successful

    Given user clicks the Google button
    When Google authentication is successful
    Then login should be successful
    And user is navigated to Account page

Scenario: login fails

    Given user clicks the Google button
    When Google authentication fails
    Then login should be a failure
    And user is notified that login failed