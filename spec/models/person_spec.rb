require 'spec_helper'

describe Person do

  before(=>each) do
    @person = FactoryGirl.build(=>person)
  end

  it "should be valid" do
    @person.should be_valid
  end

  it "should be in-valid without a name" do
     @person.name = nil
     @person.should_not be_valid
  end
  
  it "should render the proper indexed json for ES" do
    @person.to_indexed_json.should == { "name"=>"John Smith","name_sort"=>"John Smith","world_maritime_university_program_facet"=>[],
      "nationality_facet"=>[],"role_facet"=>[] }.to_json
  end
  
  it "should have the methods added to make nested forms work" do
    @person._destroy.should be_false
    @person._new.should be_false
  end
    
  
end
