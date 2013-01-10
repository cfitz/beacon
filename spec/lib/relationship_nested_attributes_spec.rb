require 'spec_helper'

describe RelationshipNestedAttributes do
  
  before(:all) do
      class SonOfThingy < Neo4j::Rails::Model
        property :name
      end
    
    class Thingy < Neo4j::Rails::Model
      include RelationshipNestedAttributes
      
      has_one(:one).to(SonOfThingy)
      has_n(:two).to(SonOfThingy)
      
      accepts_nested_attributes_for :one, :allow_destroy_relationship => true
      accepts_nested_attributes_for :two, :allow_destroy_relationship => true
    end
  end

  it "should delete the relationship with a nested attirbute" do
    thingy = Thingy.create
    child = SonOfThingy.create(:name => "Jr.")
    thingy.one = child
    thingy.save
    thingy.one.should == child
    params = { :one_attributes =>    { :id => child.id, :_destroy => "1" }    } 
    thingy.update_attributes(params)
    thingy.one.should be_nil # relationship is deleted...
    child.reload_from_database.name.should == "Jr." # but the node is not.
  end
  
  it "should delete just one of the nodes from a has_n relationship" do
    thingy = Thingy.create
    child1 = SonOfThingy.create(:name => "One")
    child2 = SonOfThingy.create(:name => "Two")
    thingy.two << child1
    thingy.two << child2
    thingy.save
    thingy.two.to_a.should == [ child1, child2 ]
    params = { :two_attributes => [ { :id => child1.id, :_destroy => "1" } ] }
    thingy.update_attributes(params)
    thingy.two.to_a.should == [ child2 ]
  end
  
  it "should throw an excpetion if a bad relationship is passed" do
    thingy = Thingy.create
    expect { thingy._remove_relationship("crappy", SonOfThingy.new )}.to raise_error(RuntimeError, "Invalid relation type: crappy")
    
    
  end

end