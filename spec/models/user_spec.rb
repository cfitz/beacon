require 'spec_helper'

describe User do

  it "should return the email for #to_s" do
   user  = FactoryGirl.create(:user)
   user.email.should == "user@wmu.se"
   user.to_s.should == "user@wmu.se"
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
  
  it "should find the user based on what's returned from OAUTH" do
     auth_hash =  OmniAuth::AuthHash.new 
    auth_hash.info = {:email => 'user@wmu.se'}
    User.should_receive(:find).with(:email => "user@wmu.se").once.and_return(FactoryGirl.create(:user))
    user = User.find_for_google_oauth2(auth_hash)
    user.email.should == "user@wmu.se"
  end
  
  it "should make a new authorized user account if the email is wmu.se" do
      auth_hash =  OmniAuth::AuthHash.new 
     auth_hash.info = {:email => 'crap@wmu.se'}
     User.should_receive(:find).with(:email => "crap@wmu.se").once.and_return(nil)
     user = User.find_for_google_oauth2(auth_hash)
     user.email.should == "crap@wmu.se"
     user.approved.should be_true
   end
  
  
  it "should make a new unauthorized user account if the email is not wmu.se" do
      auth_hash =  OmniAuth::AuthHash.new 
     auth_hash.info = {:email => 'crap@wmu.com'}
     User.should_receive(:find).with(:email => "crap@wmu.com").once.and_return(nil)
     user = User.find_for_google_oauth2(auth_hash)
     user.email.should == "crap@wmu.com"
     user.approved.should be_false
   end
  
end
