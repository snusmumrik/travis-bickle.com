require 'spec_helper'

describe "cars/edit" do
  before(:each) do
    @car = assign(:car, stub_model(Car,
      :user => nil,
      :name => "MyString",
      :type => "",
      :model => "MyString",
      :base_fare => 1,
      :meter_fare => 1
    ))
  end

  it "renders the edit car form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cars_path(@car), :method => "post" do
      assert_select "input#car_user", :name => "car[user]"
      assert_select "input#car_name", :name => "car[name]"
      assert_select "input#car_type", :name => "car[type]"
      assert_select "input#car_model", :name => "car[model]"
      assert_select "input#car_base_fare", :name => "car[base_fare]"
      assert_select "input#car_meter_fare", :name => "car[meter_fare]"
    end
  end
end
