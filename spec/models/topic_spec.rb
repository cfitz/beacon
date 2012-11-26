require 'spec_helper'

describe Topic do

  before(:each) do
    @topic = FactoryGirl.build(:topic)
  end

  it "should be ivalid" do
    @topic.should be_valid
  end

  it "should be in-valid without a name" do
     @topic.name = nil
     @topic.should_not be_valid
  end
end
