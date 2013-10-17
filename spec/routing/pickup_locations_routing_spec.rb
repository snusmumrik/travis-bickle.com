require "spec_helper"

describe PickupLocationsController do
  describe "routing" do

    it "routes to #index" do
      get("/pickup_locations").should route_to("pickup_locations#index")
    end

    it "routes to #new" do
      get("/pickup_locations/new").should route_to("pickup_locations#new")
    end

    it "routes to #show" do
      get("/pickup_locations/1").should route_to("pickup_locations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pickup_locations/1/edit").should route_to("pickup_locations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pickup_locations").should route_to("pickup_locations#create")
    end

    it "routes to #update" do
      put("/pickup_locations/1").should route_to("pickup_locations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pickup_locations/1").should route_to("pickup_locations#destroy", :id => "1")
    end

  end
end
