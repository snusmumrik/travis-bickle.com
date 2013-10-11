require 'spec_helper'

describe Location do
  before do
    @location = FactoryGirl.build(:location)
  end

  context "car_id is missing" do
    before do
      @location.car_id = nil
    end

    it { @location.should_not be_valid }
  end

  context "latitude is missing" do
    before do
      @location.latitude = nil
    end

    it { @location.should_not be_valid }
  end

  context "longitude is missing" do
    before do
      @location.longitude = nil
    end

    it { @location.should_not be_valid }
  end
end
