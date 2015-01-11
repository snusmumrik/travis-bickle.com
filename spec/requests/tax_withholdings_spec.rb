require 'spec_helper'

describe "TaxWithholdings" do
  describe "GET /tax_withholdings" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tax_withholdings_path
      response.status.should be(200)
    end
  end
end
