require 'spec_helper'

describe CorporateBody do
 
 before(:each) do
   @cb =  user = FactoryGirl.build(:corporate_body)
 end

 it "should be valid " do
   @cb.should be_valid
 end
 
 it "should be in-valid without a name" do
    @cb.name = nil
    @cb.should_not be_valid
 end

 
 
end
