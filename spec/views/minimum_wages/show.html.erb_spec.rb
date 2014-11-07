require 'spec_helper'

describe "minimum_wages/show" do
  before(:each) do
    @minimum_wage = assign(:minimum_wage, stub_model(MinimumWage,
      :user => "",
      :price => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/1/)
  end
end
