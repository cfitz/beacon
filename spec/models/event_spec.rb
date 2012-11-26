require 'spec_helper'

describe Event do
  
  before(:each) do
    @event = FactoryGirl.build(:event)
  end

  it "should be valid" do
    @event.should be_valid
  end

  it "should be in-valid without a name" do
     @event.name = nil
     @event.should_not be_valid
  end

end
