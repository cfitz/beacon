require 'spec_helper'

describe Users::OmniauthCallbacksController, "handle google_oauth2 authentication callback" do
  before :each do
      # This a Devise specific thing for functional tests. See https://github.com/plataformatec/devise/issues/closed#issue/608
      request.env["devise.mapping"] = Devise.mappings[:user]
  end
  it "should find the Authentication using the uid and provider from omniauth" do
     request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:wmu_google_oauth2] 
     
     @controller.stub!(:env).and_return({"some_other_key" => "some_other_value"})
     get :google_oauth2
     response.should redirect_to "/"
        flash[:notice].should == "Successfully authorized from Google account."
     
  end

  it "should find the Authentication using the uid and provider from omniauth" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2] 

      @controller.stub!(:env).and_return({"some_other_key" => "some_other_value"})
      get :google_oauth2
      response.should redirect_to '/'
      flash[:notice].should == "Hello! Your account is still awaiting approval." 

   end


end