require 'spec_helper'

describe SearchController do

  describe "GET 'index'" do
    it "returns http success if no params given" do
      get 'index'
      response.should be_success
    end
    
    it "should search ES is param[:q] is provided" do
      get 'index', {:q => "my search "}
      response.should be_success
      
    end
    
  end

end
