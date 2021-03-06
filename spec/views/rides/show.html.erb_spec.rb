# -*- coding: utf-8 -*-
require 'spec_helper'

describe "rides/show" do
  before(:each) do
    # @ride = assign(:ride, stub_model(Ride,
    #   :report => nil,
    #   :location => "Location",
    #   :latitude => 1.5,
    #   :longitude => 1.5
    # ))
    @ride = FactoryGirl.create(:ride)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/乗車地/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
  end
end
