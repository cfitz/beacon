# using this for now until we get more accecptance tests from people...
require 'spec_helper'


describe DocumentsHelper do
  it "should be included in the object returned by #helper" do
      included_modules = (class << helper; self; end).send :included_modules
      included_modules.should include(DocumentsHelper)
  end
  
  it "should do something" do
    document = FactoryGirl.build(:document) 
    helper.show_pdf?(document).should be_false
  end
  
  describe "render_list_item" do 
    it "should return the correct URL for the item type" do
      item = Item.new(:url => "http://catalog.wmu.se")
      helper.render_list_item(item).should ==  "<li><a href='#{item.url}'><i class='icon-book'></i></a></li>"
      item = Item.new(:url => "docs.google.com")
      helper.render_list_item(item).should ==   "<li><a href='#{item.url}'><i class='icon-file'></i></a></li>"
      item = Item.new(:url => "http://foo.com")
       helper.render_list_item(item).should ==  "<li><a href='#{item.url}'><i class='icon-file'></i><b>External Link</b></a></li>"
      item = Item.new
       helper.render_list_item(item).should == ""
    end
  end
  
  describe "item_list" do
    it "should render the item list correctly" do
       items = [ Item.new(:url => "http://catalog.wmu.se"),Item.new(:url => "docs.google.com"),  Item.new(:url => "http://foo.com") ]
       helper.item_list(items).should == "<ul class='items_list'><li><a href='http://catalog.wmu.se'><i class='icon-book'></i></a></li><li><a href='docs.google.com'><i class='icon-file'></i></a></li><li><a href='http://foo.com'><i class='icon-file'></i><b>External Link</b></a></li></ul>"   
    end
   end
   
  describe "author_list" do
      it "should render the item list correctly" do
         authors = [ Person.new(:name => "Ben"), Person.new(:name => "Jerry"), Person.new(:name => "Chris")]
         helper.authors_list(authors).should == "<dd class=\"authors_list\"><a href=\"/people\"> Ben;</a><a href=\"/people\"> Jerry;</a><a href=\"/people\"> Chris</a></dd>"
      end
  end
    
     describe "topic_list" do
        it "should render the item list correctly" do
           topics = [ Topic.new(:name => "Ben"), Topic.new(:name => "Jerry"), Topic.new(:name => "Chris")]
           helper.topics_list(topics).should == "<dd class=\"topics_list\"><a href=\"/topics\"> Ben,</a><a href=\"/topics\"> Jerry,</a><a href=\"/topics\"> Chris</a></dd>"
        end
      end
  
end