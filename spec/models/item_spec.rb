require 'spec_helper'

describe Item do
 
 before(:each) do
   @item = FactoryGirl.build(:item_with_document)
 end
 
 it "should be valid" do
   @item.should be_valid
 end
 
 it "should not be valid without url" do
   @item.url = nil
   @item.should_not be_valid
 end
 
 
 it "should return embed html" do
   @item.embed.should == "<iframe src='http://beacon.io'></iframe>"
 end


 it "should return return the right name even if item type is not set" do
   @item.name.should == "View Document"
 end
 
  it "should return the item_type as a name" do
    @item.item_type = "PDF"
    @item.name.should == @item.item_type
  end
  
  it "should return the titel of the parent document" do
    @item.title.should == "My Document Title"
  end
  
  it "should return the titel of the parent document" do
     @item.summary.should == "My Document Summary"
   end
   
   it "should have the extra methods to make nested form work" do
     @item._destroy.should be_false
   end
  
end
