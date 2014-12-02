require 'spec_helper'

describe "inspections/edit" do
  before(:each) do
    @inspection = assign(:inspection, stub_model(Inspection,
      :car => nil,
      :span => 1
    ))
  end

  it "renders the edit inspection form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", inspection_path(@inspection), "post" do
      assert_select "input#inspection_car[name=?]", "inspection[car]"
      assert_select "input#inspection_span[name=?]", "inspection[span]"
    end
  end
end
