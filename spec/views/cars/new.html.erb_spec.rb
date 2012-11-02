require 'spec_helper'

describe "cars/new" do
  before(:each) do
    assign(:car, stub_model(Car,
      :user => nil,
      :name => "MyString",
      :type => "",
      :model => "MyString",
      :base_fare => 1,
      :meter_fare => 1
    ).as_new_record)
  end

  it "renders new car form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cars_path, :method => "post" do
      assert_select "input#car_user", :name => "car[user]"
      assert_select "input#car_name", :name => "car[name]"
      assert_select "input#car_type", :name => "car[type]"
      assert_select "input#car_model", :name => "car[model]"
      assert_select "input#car_base_fare", :name => "car[base_fare]"
      assert_select "input#car_meter_fare", :name => "car[meter_fare]"
    end
  end
end
