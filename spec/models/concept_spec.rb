require 'spec_helper'

describe Concept do
 
  before(:each) do
    @concept =  FactoryGirl.build(:concept)
  end

  it "should be  valid without a name" do
    @concept.should be_valid
  end
  
  it "should be in-valid without a name" do
     @concept.name = nil
     @concept.should_not be_valid
  end
  
  
end
