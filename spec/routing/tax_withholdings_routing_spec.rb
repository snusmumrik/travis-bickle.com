require "spec_helper"

describe TaxWithholdingsController do
  describe "routing" do

    it "routes to #index" do
      get("/tax_withholdings").should route_to("tax_withholdings#index")
    end

    it "routes to #new" do
      get("/tax_withholdings/new").should route_to("tax_withholdings#new")
    end

    it "routes to #show" do
      get("/tax_withholdings/1").should route_to("tax_withholdings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tax_withholdings/1/edit").should route_to("tax_withholdings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tax_withholdings").should route_to("tax_withholdings#create")
    end

    it "routes to #update" do
      put("/tax_withholdings/1").should route_to("tax_withholdings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tax_withholdings/1").should route_to("tax_withholdings#destroy", :id => "1")
    end

  end
end
