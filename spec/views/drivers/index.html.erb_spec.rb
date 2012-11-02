require 'spec_helper'

describe "drivers/index" do
  before(:each) do
    assign(:drivers, [
      stub_model(Driver,
        :user => nil,
        :name => "Name",
        :blood_type => "Blood Type",
        :licence_number => "Licence Number"
      ),
      stub_model(Driver,
        :user => nil,
        :name => "Name",
        :blood_type => "Blood Type",
        :licence_number => "Licence Number"
      )
    ])
  end

  it "renders a list of drivers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Blood Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Licence Number".to_s, :count => 2
  end
end
