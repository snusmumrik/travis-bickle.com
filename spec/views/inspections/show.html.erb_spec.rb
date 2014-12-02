require 'spec_helper'

describe "inspections/show" do
  before(:each) do
    @inspection = assign(:inspection, stub_model(Inspection,
      :car => nil,
      :span => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/1/)
  end
end
