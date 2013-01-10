require 'spec_helper'

describe Document do

  it "should return an array of facets" do
    Document.facets.should == [:format_facet, :world_maritime_university_program_facet, :date, :creator_nationality_facet] 
  end
  
  describe "relationship methods" do
  
    it "should return a propertly formated json to be indexed by elasticsearhc" do
      document = FactoryGirl.create(:document)
      document.creators << FactoryGirl.create(:person)
      document.items << Item.new(:url => "http://google.com", :item_type => "pdf")
      document.topics << Topic.new(:name => "Testing Rails")
      document.to_indexed_json.should == {"title"=>"My Document Title","name"=>"My Document Title", "name_sort"=>"My Document Title","content"=>nil,"summary"=>"My Document Summary","topics"=>["Testing Rails"],"creators"=>["John Smith"],"items"=>["http://google.com"],"format_facet"=>["pdf"],"world_maritime_university_program_facet"=>[],"creator_nationality_facet"=>[],"date"=>"2012-07-21"}.to_json
    end
  
    it "should return a hash of the creators and their roles" do
      document = FactoryGirl.create(:document)
      creator = FactoryGirl.create(:person)
      document.creators << creator
      document.creators_rels.first.role = "Author"
      document.creators_by_roles.should == { "Author" => [creator]}
    end
    
    
      it "#creator_rels_attributes should work for nested form" do
        document = Document.new
        document.creators_rels_attributes=(  {"blah_blah_new" => { "class" => "Person", "role" => "creator", "end_node_name" => "Joey Joe Joe"}} )
        document = document.reload_from_database
        document.creators.first.name.should == "Joey Joe Joe"
        document.creators_rels_attributes=(  {"blah_blah_update" => { "id" => document.creators_rels.first.id, "role" => "author" }} )
        document.creators_rels.first.role.should =="author"
        document.creators_rels_attributes=(  {"blah_blah_destroy" => { "__destroy" => "1",  "id" => document.creators_rels.first.id }} )
        document.creators.first.should be_nil
      end
      
      it "should accecpted nested attributes" do
        params = { :title => "Foo Doc", :items_attributes => [{ :url => "http://foo.com" }] }
        document = Document.create(params)
        document = document.reload_from_database
        item = document.items.first
        item.url.should == "http://foo.com"
        params = {  :items_attributes => [{ :id => item.id, :_destroy => "1"  }] }
        document.update_attributes(params)
        document.save
        document = document.reload_from_database
        document.items.first.should be_nil
      end

        it "should accecpted nested attributes for delete relationships" do
          document = Document.create(:title => "Foobared")
          topic =  Topic.create(:name => "Footopiced")
          document.topics << topic
          params = {  :topics_attributes => [{ :id => topic.id, :_destroy => "1"  }] }
          document.update_attributes(params)
          document.topics.first.should be_nil
        end
  
        it "should accecpted nested attributes for delete relationships" do
          document = Document.create(:title => "Foobared")
          topic =  Topic.create(:name => "Footopiced")
          params = {  :topics_attributes => [{ :id => topic.id  }] }
          document.update_attributes(params)
          document.topics.first.id.should == topic.id
        end
        
       
  
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
   
   it "#to_param should be nil if not persisted" do
     document = Document.new
     document.persisted?.should be_false
     document.to_param.should be_nil
   end
   
   it "#to_param should be neo_id if not slugged" do
      document = Document.create!
      document.should_receive(:slugged?).twice.and_return(false) #mock this out. documents should always be slugged, but this is a just in case sceneria. 
      document.persisted?.should be_true
      document.slugged?.should be_false
      document.to_param.should == document.id
    end
   

end
