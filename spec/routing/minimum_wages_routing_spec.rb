require "spec_helper"

describe MinimumWagesController do
  describe "routing" do

    it "routes to #index" do
      get("/minimum_wages").should route_to("minimum_wages#index")
    end

    it "routes to #new" do
      get("/minimum_wages/new").should route_to("minimum_wages#new")
    end

    it "routes to #show" do
      get("/minimum_wages/1").should route_to("minimum_wages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/minimum_wages/1/edit").should route_to("minimum_wages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/minimum_wages").should route_to("minimum_wages#create")
    end

    it "routes to #update" do
      put("/minimum_wages/1").should route_to("minimum_wages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/minimum_wages/1").should route_to("minimum_wages#destroy", :id => "1")
    end

  end
end
