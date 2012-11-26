require 'spec_helper'

describe Creator do
 
  before(:each) do
    @creator = Creator.new
    @creator.role = "player"
   end

   it "should be valid" do
     @creator.should be_valid
   end

   it "should return the possbile roles" do
     @creator.possible_roles.should =~   [["Author", "author"], ["Editor", "editor"], ["Player", "player"]]
   end
   
   it "should return a list of the default/common roles" do 
     Creator.default_roles.should =~  [["Author", "author"], ["Editor", "editor"]]
   end
 
 
end
