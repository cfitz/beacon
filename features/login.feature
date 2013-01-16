Feature: Sign up
    In order to sign up for an account
    A visitor
    Should register for an account
 
    Scenario: Register for an account
        Given I am on the home page
        When I follow "Sign In"
        And I click "Request an account"
        And I fill in "user[email]" with "foo@bar.com"
        Then I should see "Hello! You account is awaiting approval. We will get back to you shortly."