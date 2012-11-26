require 'spec_helper'

describe Thing do

  before(:each) do
    @thing = FactoryGirl.build(:thing)
  end

  it "should be valid" do
    @thing.should be_valid
  end

  it "should be in-valid without a name" do
     @thing.name = nil
     @thing.should_not be_valid
  end
end
