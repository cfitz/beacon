require 'acceptance/acceptance_helper'


feature "Pagination", %q{
  In order to see list of items
  A user
  Should be able to paginate on the index page.
} do

  background do
    (1..100).each { |n| Topic.create( :name => "Topic #{n.to_s}!")}
  end

  scenario "Pagination on index page" do
    visit '/topics'
    page.should have_content('Topic 1!')
    page.should have_content('Topic 2!')
    click("2")
    page.should have_content("Topic 26!")
    page.should have_content("Topic 30!")
    click("3")
    page.should have_content("Topic 51!")
    page.should have_content("Topic 60!")
    click("1")
    page.should have_content('Topic 1!')
    page.should have_content('Topic 2!')
  end

end

