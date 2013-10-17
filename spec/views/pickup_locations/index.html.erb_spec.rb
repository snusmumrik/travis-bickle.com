require 'spec_helper'

describe "pickup_locations/index" do
  before(:each) do
    assign(:pickup_locations, [
      stub_model(PickupLocation,
        :user => nil,
        :name => "Name",
        :address => "Address",
        :latitude => 1.5,
        :longitude => 1.5,
        :gmaps => false
      ),
      stub_model(PickupLocation,
        :user => nil,
        :name => "Name",
        :address => "Address",
        :latitude => 1.5,
        :longitude => 1.5,
        :gmaps => false
      )
    ])
  end

  it "renders a list of pickup_locations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
