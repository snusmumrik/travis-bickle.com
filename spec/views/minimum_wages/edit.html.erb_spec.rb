require 'spec_helper'

describe "minimum_wages/edit" do
  before(:each) do
    @minimum_wage = assign(:minimum_wage, stub_model(MinimumWage,
      :user => "",
      :price => 1
    ))
  end

  it "renders the edit minimum_wage form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", minimum_wage_path(@minimum_wage), "post" do
      assert_select "input#minimum_wage_user[name=?]", "minimum_wage[user]"
      assert_select "input#minimum_wage_price[name=?]", "minimum_wage[price]"
    end
  end
end
