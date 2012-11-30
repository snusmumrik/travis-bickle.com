require 'spec_helper'

describe "rests/index" do
  before(:each) do
    assign(:rests, [
      stub_model(Rest,
        :report => nil,
        :location => "Location",
        :latitude => 1.5,
        :longitude => 1.5
      ),
      stub_model(Rest,
        :report => nil,
        :location => "Location",
        :latitude => 1.5,
        :longitude => 1.5
      )
    ])
  end

  it "renders a list of rests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
