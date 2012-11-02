require 'spec_helper'

describe "check_points/index" do
  before(:each) do
    assign(:check_points, [
      stub_model(CheckPoint,
        :user => nil,
        :name => "Name"
      ),
      stub_model(CheckPoint,
        :user => nil,
        :name => "Name"
      )
    ])
  end

  it "renders a list of check_points" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
