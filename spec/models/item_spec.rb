require 'spec_helper'

describe Item do
 
 before(:each) do
   @item = Item.new
 end
 
 it "should be valid" do
   @item.should be_valid
 end
 
 it "should return false if public is not set" do 
   @item.public?.should be_false
 end
 
 it "should return true if public is true" do
    @item.open_access = true
    @item.public?.should be_true
 end
 
 it "should attach files properly" do
   SecureRandom.should_receive(:urlsafe_base64).and_return("xxx666")
   @item.attachment = File.new(__FILE__)
   @item.save
   puts @item.url # "http://s3.amazonaws.com/wmu-library/test/xxx666/item_spec.rb?1346524944"
   @item.url.split("?").first.should eq("http://s3.amazonaws.com/wmu-library/test/xxx666/item_spec.rb")   
 end
 

 it "should format the document viewer json correclt" do
   @doc = Document.create(:title => "A Test Document", :summary => "a test")
   @item.uuid = "xxx666"
   @item.pages = "3"
   @item.attachment = File.new(__FILE__)
   
   @doc.items << @item
   @item.save
   test_json = {
     "title" => "A Test Document",
     "description" =>   "a test",
     "id" => @doc.id,
     "pages" => "3",
     "resources" => {
       "page" => { "text" => "http://s3.amazonaws.com/wmu-library/test/xxx666/text/{page}.txt" , "image" => "http://s3.amazonaws.com/wmu-library/test/xxx666/images/{size}/{page}.png" },
       "pdf"  =>  @item.url,
       "search" => "http://"
     }
   }.to_json
   
   @item.to_document_json.should == test_json
   
   
 end
  
  
end
