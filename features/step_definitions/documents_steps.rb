require 'factory_girl'

Given /^I have documents?$/ do
  (1..3).each { FactoryGirl.create(:document) }
end