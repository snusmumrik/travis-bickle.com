require 'spec_helper'

describe "tax_withholdings/index" do
  before(:each) do
    assign(:tax_withholdings, [
      stub_model(TaxWithholding,
        :working_days => 1,
        :working_hours => 2,
        :holiday_working_hours => 3,
        :night_working_hours => 4,
        :extra_working_hours => 5,
        :base_salary => 6,
        :percentage_pay => 7,
        :holiday_pay => 8,
        :night_pay => 9,
        :extra_pay => 10,
        :no_absence_pay => 11,
        :no_accident_pay => 12,
        :long_service_pay => 13,
        :real_salary => 14,
        :health_insurance => 15,
        :nursing_insurance => 16,
        :pension => "",
        :unemployment_isurance => 17,
        :taxables => 18,
        :dependents => 19,
        :calculated_tax_amount => 20,
        :adjustment => 21,
        :net_collection => 22,
        :resident_tax => 23,
        :bonus => 24,
        :social_insurance => 25
      ),
      stub_model(TaxWithholding,
        :working_days => 1,
        :working_hours => 2,
        :holiday_working_hours => 3,
        :night_working_hours => 4,
        :extra_working_hours => 5,
        :base_salary => 6,
        :percentage_pay => 7,
        :holiday_pay => 8,
        :night_pay => 9,
        :extra_pay => 10,
        :no_absence_pay => 11,
        :no_accident_pay => 12,
        :long_service_pay => 13,
        :real_salary => 14,
        :health_insurance => 15,
        :nursing_insurance => 16,
        :pension => "",
        :unemployment_isurance => 17,
        :taxables => 18,
        :dependents => 19,
        :calculated_tax_amount => 20,
        :adjustment => 21,
        :net_collection => 22,
        :resident_tax => 23,
        :bonus => 24,
        :social_insurance => 25
      )
    ])
  end

  it "renders a list of tax_withholdings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
    assert_select "tr>td", :text => 13.to_s, :count => 2
    assert_select "tr>td", :text => 14.to_s, :count => 2
    assert_select "tr>td", :text => 15.to_s, :count => 2
    assert_select "tr>td", :text => 16.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 17.to_s, :count => 2
    assert_select "tr>td", :text => 18.to_s, :count => 2
    assert_select "tr>td", :text => 19.to_s, :count => 2
    assert_select "tr>td", :text => 20.to_s, :count => 2
    assert_select "tr>td", :text => 21.to_s, :count => 2
    assert_select "tr>td", :text => 22.to_s, :count => 2
    assert_select "tr>td", :text => 23.to_s, :count => 2
    assert_select "tr>td", :text => 24.to_s, :count => 2
    assert_select "tr>td", :text => 25.to_s, :count => 2
  end
end
