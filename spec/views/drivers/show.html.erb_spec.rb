require 'spec_helper'

describe "drivers/show" do
  before(:each) do
    @driver = assign(:driver, stub_model(Driver,
      :user => nil,
      :name => "Name",
      :blood_type => "Blood Type",
      :licence_number => "Licence Number"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Blood Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Licence Number/)
  end
end
