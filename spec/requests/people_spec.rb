require 'spec_helper'

describe "People" do
  describe "GET /people" do
    it "works! (now write some real specs)" do
       Person.tire.index.delete
       Person.create!( {:name => "Foo" })
       Person.all.each { |p| p.save }
        #Document.tire.index.create
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get people_path
      response.status.should be(200)
    end
  end
end
