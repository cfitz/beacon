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

  it "should have the extra methods to make nested form work" do
    @topic._destroy.should be_false
  end

  it "should return proper json for elastic search" do
     @topic.to_indexed_json.should == { "name" => "MyTopic","world_maritime_university_program_facet" => [],"related_documents" => 0}.to_json
  end

  it "should return the proper programs related to the topic" do
    @topic.documents << FactoryGirl.build(:document)
    @topic.documents.first.creators << FactoryGirl.build(:person)
    @topic.documents.first.creators.first.has_membership << FactoryGirl.build(:corporate_body)
    
    @topic.world_maritime_university_programs.should == [ "A Corporation"]
  end


end
