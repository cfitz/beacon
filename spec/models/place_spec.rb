require 'spec_helper'

describe Place do

  before(:each) do
    @place =FactoryGirl.build(:place)
  end

  it "should be valid" do
    puts @place.name 
    @place.should be_valid
  end

  it "should be in-valid without a name" do
     @place.name = nil
     @place.should_not be_valid
  end


end
