require 'acceptance/acceptance_helper'

=begin

feature "Sign_In", %q{
  In order to get access to protected sections of the site
  A user
  Should be able to sign in
} do



  scenario "WMU User logs in for first time" do
    visit '/articles'
    page.should have_content('One')
    page.should have_content('Two')
  end

end


Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in
  
  Scenario: WMU User logs in for first time
    Given I do not exist as a user
    When I sign in with valid credentials
    Then I see a successful google sign in message
    And I should be on the home page
=end
