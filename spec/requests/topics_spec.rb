require 'spec_helper'

describe "Topics" do
  describe "GET /topics" do
    it "works! (now write some real specs)" do
      FactoryGirl.create(:topic)
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get topics_path
      response.status.should be(200)
    end
  end
end
