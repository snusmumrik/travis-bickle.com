require 'spec_helper'

describe "inspections/index" do
  before(:each) do
    assign(:inspections, [
      stub_model(Inspection,
        :car => nil,
        :span => 1
      ),
      stub_model(Inspection,
        :car => nil,
        :span => 1
      )
    ])
  end

  it "renders a list of inspections" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
