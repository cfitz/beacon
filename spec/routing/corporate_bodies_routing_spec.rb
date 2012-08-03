require "spec_helper"

describe CorporateBodiesController do
  describe "routing" do

    it "routes to #index" do
      get("/corporate_bodies").should route_to("corporate_bodies#index")
    end

    it "routes to #new" do
      get("/corporate_bodies/new").should route_to("corporate_bodies#new")
    end

    it "routes to #show" do
      get("/corporate_bodies/1").should route_to("corporate_bodies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/corporate_bodies/1/edit").should route_to("corporate_bodies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/corporate_bodies").should route_to("corporate_bodies#create")
    end

    it "routes to #update" do
      put("/corporate_bodies/1").should route_to("corporate_bodies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/corporate_bodies/1").should route_to("corporate_bodies#destroy", :id => "1")
    end

  end
end
