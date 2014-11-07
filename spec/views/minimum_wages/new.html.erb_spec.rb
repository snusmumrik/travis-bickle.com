require 'spec_helper'

describe "minimum_wages/new" do
  before(:each) do
    assign(:minimum_wage, stub_model(MinimumWage,
      :user => "",
      :price => 1
    ).as_new_record)
  end

  it "renders new minimum_wage form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", minimum_wages_path, "post" do
      assert_select "input#minimum_wage_user[name=?]", "minimum_wage[user]"
      assert_select "input#minimum_wage_price[name=?]", "minimum_wage[price]"
    end
  end
end
