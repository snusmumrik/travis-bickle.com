require 'spec_helper'

describe "rides/edit" do
  before(:each) do
    # @ride = assign(:ride, stub_model(Ride,
    #   :report => nil,
    #   :location => "MyString",
    #   :latitude => 1.5,
    #   :longitude => 1.5
    # ))
    @ride = FactoryGirl.build(:ride)
  end

  it "renders the edit ride form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => rides_path(@ride), :method => "post" do
      assert_select "input#ride_report", :name => "ride[report]"
      assert_select "input#ride_location", :name => "ride[location]"
      assert_select "input#ride_latitude", :name => "ride[latitude]"
      assert_select "input#ride_longitude", :name => "ride[longitude]"
    end
  end
end
