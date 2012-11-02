require 'spec_helper'

describe "drivers/edit" do
  before(:each) do
    @driver = assign(:driver, stub_model(Driver,
      :user => nil,
      :name => "MyString",
      :blood_type => "MyString",
      :licence_number => "MyString"
    ))
  end

  it "renders the edit driver form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => drivers_path(@driver), :method => "post" do
      assert_select "input#driver_user", :name => "driver[user]"
      assert_select "input#driver_name", :name => "driver[name]"
      assert_select "input#driver_blood_type", :name => "driver[blood_type]"
      assert_select "input#driver_licence_number", :name => "driver[licence_number]"
    end
  end
end
