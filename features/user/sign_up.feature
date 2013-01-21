Feature: Sign up
    In order to sign up for an account
    A visitor
    I want to be able to sign up
    
    Background:
      Given I am not logged in
    
   Scenario: User signs up with valid data
     Given I do not exist as a user
     When I sign up with valid user data
     Then I should see a successful sign up message
     