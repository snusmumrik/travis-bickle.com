require "spec_helper"

describe RestsController do
  describe "routing" do

    it "routes to #index" do
      get("/rests").should route_to("rests#index")
    end

    it "routes to #new" do
      get("/rests/new").should route_to("rests#new")
    end

    it "routes to #show" do
      get("/rests/1").should route_to("rests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/rests/1/edit").should route_to("rests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/rests").should route_to("rests#create")
    end

    it "routes to #update" do
      put("/rests/1").should route_to("rests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/rests/1").should route_to("rests#destroy", :id => "1")
    end

  end
end
