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
  
  it "should render the proper indexed json for ES" do
    @person.should_receive(:has_membership).and_return([FactoryGirl.build(:corporate_body)])
    @person.should_receive(:has_nationality).and_return([FactoryGirl.build(:place)])
    @person.should_receive(:roles).and_return(["writer"])
    
    @person.to_indexed_json.should == { "name"=>"John Smith","name_sort"=>"John Smith","world_maritime_university_program_facet"=>["A Corporation"],
      "nationality_facet"=>["A Place"],"role_facet"=>["Writer"] }.to_json
  end
  
  it "should have the methods added to make nested forms work" do
    @person._destroy.should be_false
    @person._new.should be_false
  end
  
  
  
end
