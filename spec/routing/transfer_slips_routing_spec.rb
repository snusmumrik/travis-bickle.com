require "spec_helper"

describe TransferSlipsController do
  describe "routing" do

    it "routes to #index" do
      get("/transfer_slips").should route_to("transfer_slips#index")
    end

    it "routes to #new" do
      get("/transfer_slips/new").should route_to("transfer_slips#new")
    end

    it "routes to #show" do
      get("/transfer_slips/1").should route_to("transfer_slips#show", :id => "1")
    end

    it "routes to #edit" do
      get("/transfer_slips/1/edit").should route_to("transfer_slips#edit", :id => "1")
    end

    it "routes to #create" do
      post("/transfer_slips").should route_to("transfer_slips#create")
    end

    it "routes to #update" do
      put("/transfer_slips/1").should route_to("transfer_slips#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/transfer_slips/1").should route_to("transfer_slips#destroy", :id => "1")
    end

  end
end
