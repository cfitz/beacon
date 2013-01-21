require 'spec_helper'

describe CorporateBody do
 
 before(:each) do
   @cb = FactoryGirl.build(:corporate_body)
 end

 it "should be valid " do
   @cb.should be_valid
 end
 
 it "should be in-valid without a name" do
    @cb.name = nil
    @cb.should_not be_valid
 end
 
 it "should have some added methods to make the form work" do
   @cb._destroy.should be_false
   @cb._new.should be_false
 end

 
 
end
