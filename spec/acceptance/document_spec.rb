require 'acceptance/acceptance_helper'

feature "Documents", %q{
  In order to see the index of documents
  A visitor
  Should be able to see a list of documents. 
 
} do

  background do
  #  DatabaseCleaner.clean
  #  IndexCleaner.clean
  #  FactoryGirl.create(:topic)
    (1..5).each { doc = FactoryGirl.create(:document); (1..3).each { doc.topics << FactoryGirl.create(:topic) } } # if we create topics, we create documents.
  end

  scenario "WMU User logs in for first time" do
    visit '/documents'
    page.should have_content('My Document Title')
    page.should have_content('2012-07-21')
  end

end