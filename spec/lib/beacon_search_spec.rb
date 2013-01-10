require 'spec_helper'

describe BeaconSearch do

  before(:all) do
      class Child < Neo4j::Rails::Model
        property :name
      end
    
    class Thingy < Neo4j::Rails::Model
      include BeaconSearch
      
      def self.facets
          [ :funky_facet ]
      end
      
      has_n(:funky)
      
      def to_indexed_json
              json = {
                :funky_facet => funky.collect { |f| f.name.downcase }
              }
              json.to_json
      end
      
       mapping do
         indexes :funky_facet, :type => "string", :index =>"not_analyzed"
       end
      
    end
  end
  
  before(:each) do 
    Tire.index(Thingy.index_name).refresh
  end
  
  after(:each) do 
   Tire.index(Thingy.index_name).delete
  end
  
  
  describe "facets integration" do
    
    it "should return the correct facet results" do
       child1 = Child.create(:name => "One" )
       child2 = Child.create(:name => "Two" )
       child3 = Child.create(:name => "Three" )
       thing = Thingy.create
       thing.funky << child1 
       thing.save
       
       thing2 = Thingy.create
       thing2.funky << child2 
       thing2.save
       [thing, thing2].each { |t| t.index.refresh }
       
       results = Thingy.elastic_search({ :facet => ["funky_facet:one"]})
       # results.length.should == 1
       results.first.should == thing
       results.include?(thing2).should be_false
    end
  end
end