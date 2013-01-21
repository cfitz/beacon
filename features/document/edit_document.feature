Feature: Document page
  
  Background:
    Given I have documents 
  
  Scenario: Unauthed visitor cannot edit a document
    Given I do not exist as a user
    And I am on the documents page
    Then I should not see "edit"