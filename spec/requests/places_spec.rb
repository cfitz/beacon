require 'spec_helper'

describe "Places" do
  describe "GET /places" do
    it "works! (now write some real specs)" do
      place = Place.create! ( { :name => "foo", :place_type => "Country" })
      place.save
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get places_path
      response.status.should be(200)
    end
  end
end
