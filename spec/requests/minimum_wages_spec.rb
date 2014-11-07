require 'spec_helper'

describe "MinimumWages" do
  describe "GET /minimum_wages" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get minimum_wages_path
      response.status.should be(200)
    end
  end
end
