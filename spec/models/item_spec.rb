require 'spec_helper'

describe Item do
 
 before(:each) do
   @item = FactoryGirl.build(:item)
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
  
  
end
