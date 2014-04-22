require 'spec_helper'

describe "TransferSlips" do
  describe "GET /transfer_slips" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get transfer_slips_path
      response.status.should be(200)
    end
  end
end
