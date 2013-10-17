require 'spec_helper'

describe PickupLocation do
  before do
    @pickup_location = FactoryGirl.build(:pickup_location)
  end

  context "name is missing" do
    before do
      @pickup_location.name = nil
    end

    it { @pickup_location.should_not be_valid }
  end
end
