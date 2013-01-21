require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegistrationsController do
  include ControllerMacros
  include Devise::TestHelpers
  
  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  
   it "should use RegistrationController" do
       controller.should be_an_instance_of(RegistrationsController)
    end


    describe "#create" do
      
      it "should keep a user not as approved and admin if user is not authed" do
        params = FactoryGirl.attributes_for(:user)
        post :create, { :user => params } 
        response.should redirect_to('/')
        flash[:notice].should == "Hello! You account is awaiting approval. We will get back to you shortly."
        user = User.all.first
        user.admin?.should be_false
        user.approved?.should be_false
      end
      
      
    end
    
    
    describe "#new" do
      
      it "should allow users to see the registration page" do
        get :new
        response.should_not redirect_to('/')
        response.should be_success
      end
    end
    
  describe  "#update nonadmin" do
   
    it "should not only nonallow admins to update registrations" do
      get :update, :id => 666, :approved => true, :email => "foobar@foofoo.com"
      response.should redirect_to("/users/sign_in")
      response.should_not be_success
    end
  end
  
  describe "#update admin" do
    login_admin
      it "should only allow admins to update registrations" do
        pending
        User.should_receive(:find).twice.and_return(@user)
        @user.should_receive(:update_attributes).once.and_return(true)
        get :update, :id => 666, :approved => true, :email => "foobar@foofoo.com"
        response.should_not redirect_to("/users/sign_in")
        response.should be_success
      end
  end


end  
