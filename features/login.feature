Feature: logging into account

    As a user using the site
    So that I can group my polls
    I want to login to my account

Scenario: login is successful

    Given I am on the home page
    When I click Google Login 
    Then I should see "Signed In"
    And I am navigated to Account page

