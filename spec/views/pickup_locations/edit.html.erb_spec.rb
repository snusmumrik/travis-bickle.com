require 'spec_helper'

describe "pickup_locations/edit" do
  before(:each) do
    @pickup_location = assign(:pickup_location, stub_model(PickupLocation,
      :user => nil,
      :name => "MyString",
      :address => "MyString",
      :latitude => 1.5,
      :longitude => 1.5,
      :gmaps => false
    ))
  end

  it "renders the edit pickup_location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", pickup_location_path(@pickup_location), "post" do
      assert_select "input#pickup_location_user[name=?]", "pickup_location[user]"
      assert_select "input#pickup_location_name[name=?]", "pickup_location[name]"
      assert_select "input#pickup_location_address[name=?]", "pickup_location[address]"
      assert_select "input#pickup_location_latitude[name=?]", "pickup_location[latitude]"
      assert_select "input#pickup_location_longitude[name=?]", "pickup_location[longitude]"
      assert_select "input#pickup_location_gmaps[name=?]", "pickup_location[gmaps]"
    end
  end
end
