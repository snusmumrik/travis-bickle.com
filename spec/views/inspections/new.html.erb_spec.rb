require 'spec_helper'

describe "inspections/new" do
  before(:each) do
    assign(:inspection, stub_model(Inspection,
      :car => nil,
      :span => 1
    ).as_new_record)
  end

  it "renders new inspection form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", inspections_path, "post" do
      assert_select "input#inspection_car[name=?]", "inspection[car]"
      assert_select "input#inspection_span[name=?]", "inspection[span]"
    end
  end
end
