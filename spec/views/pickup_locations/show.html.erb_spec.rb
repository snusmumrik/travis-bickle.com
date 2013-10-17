require 'spec_helper'

describe "pickup_locations/show" do
  before(:each) do
    @pickup_location = assign(:pickup_location, stub_model(PickupLocation,
      :user => nil,
      :name => "Name",
      :address => "Address",
      :latitude => 1.5,
      :longitude => 1.5,
      :gmaps => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Name/)
    rendered.should match(/Address/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/false/)
  end
end
