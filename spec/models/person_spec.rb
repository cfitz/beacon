require 'spec_helper'

describe Person do

  before(:each) do
    @person = FactoryGirl.build(:person)
  end

  it "should be valid" do
    @person.should be_valid
  end

  it "should be in-valid without a name" do
     @person.name = nil
     @person.should_not be_valid
  end
end
