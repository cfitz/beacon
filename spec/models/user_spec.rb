require 'spec_helper'

describe User do

  it "should return the email for #to_s" do
   user  = FactoryGirl.create(:user)
   user.email.should == "user@crap.crap"
   user.to_s.should == "user@crap.crap"
  end
  
  it "should return false if approved is nil or false" do
    user = FactoryGirl.create(:user_not_approved)
    user.approved.should be_nil
    user.approved?.should be_false
  end
  
  it "should return false if admin is nil" do
    user = FactoryGirl.create(:user_not_approved)
    user.admin.should be_nil
    user.admin?.should be_false
  end
  
  it "should return true if active_for_authentication? is called" do
    user = FactoryGirl.create(:user_not_approved)
    user.active_for_authentication?.should be_false
  end
  
  it "should return the right message if active_for_authentication? is called" do
    user = FactoryGirl.create(:user_not_approved)
    user.inactive_message.should == :not_approved
    user = FactoryGirl.create(:user)
    user.inactive_message.should == :inactive
    
    
  end
  
end
