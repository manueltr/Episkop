Feature: logging out of account

    As a user using the site
    So that I can change accounts
    I want to logout to my account

Scenario: login is successful

    Given I am on the Account page
    When I click Log out
    Then I should be Signed Out
    And I am navigated to Home page

