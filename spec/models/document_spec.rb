require 'spec_helper'

describe Document do

  it "should return an array of facets" do
    Document.facets.should == [:format, :program_facets]
  end
  
  it "should return a propertly formated json to be indexed by elasticsearhc" do
    document = FactoryGirl.create(:document)
    document.creators << FactoryGirl.create(:person)
    document.items << Item.new(:url => "http://google.com", :item_type => "pdf")
    document.topics << Topic.new(:name => "Testing Rails")
    document.to_indexed_json.should == {"title"=>"MyString","content" => nil, "summary"=>"MyString",
      "topic_facets"=>["Testing Rails"],"program_facets"=>[],"creators"=>["John Smith"],"topics"=>["Testing Rails"],
      "items"=>["http://google.com"],"date" =>"2012-07-21"}.to_json
  end
  
  it "should return a hash of the creators and their roles" do
    document = FactoryGirl.create(:document)
    creator = FactoryGirl.create(:person)
    document.creators << creator
    document.creators_rels.first.role = "Author"
    document.creators_by_roles.should == { "Author" => [creator]}
  end

  it "should return the first google docs item for pdf_item" do
    document = FactoryGirl.create(:document)
    item = Item.new(:url => "http://docs.google.com/123", :item_type => "pdf")
    document.items << item
    document.pdf_item.should == item
  end


  it "should remove the relationship when using the _remove_relationship method" do
    document = FactoryGirl.create(:document)
    item = Item.new(:url => "http://docs.google.com/123", :item_type => "pdf")
    document.items << item
    document._remove_relationship("items", item)
    document
  end

  it "should return the title for #name" do
    document = FactoryGirl.create(:document)
    document.name.should == document.title
  end
  
  it "should make sure it's titled and have a url safe slug" do
    document = Document.create!(:title => "This is a Test Document")
    document.slug.should == "this_is_a_test_document"
  end
  
  it "should return an array of available item type formats" do
    document =  Document.create!(:title => "This is a Test Document")
    document.items =  [ Item.create!(:item_type => "pdf", :url => "http://1"), Item.create!(:item_type => "bar", :url => "http://2")] 
    document.save
    document.available_formats.should == ["pdf", "bar"]
  end

  it "should make sure it's titled and have a url safe slug even if there's a long ass title" do
     title = "Foo "
     for i in 0 ... 100 
       title << " Bar "
     end
     document = Document.create!(:title => title)
     document.slug.length.should < 50
     document.slug.should == "foo_bar_bar_bar_bar_bar_bar_bar_bar_bar_bar_bar"
   end


end
