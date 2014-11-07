require 'spec_helper'

describe "minimum_wages/index" do
  before(:each) do
    assign(:minimum_wages, [
      stub_model(MinimumWage,
        :user => "",
        :price => 1
      ),
      stub_model(MinimumWage,
        :user => "",
        :price => 1
      )
    ])
  end

  it "renders a list of minimum_wages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
