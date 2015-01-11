require 'spec_helper'

describe "tax_withholdings/new" do
  before(:each) do
    assign(:tax_withholding, stub_model(TaxWithholding,
      :working_days => 1,
      :working_hours => 1,
      :holiday_working_hours => 1,
      :night_working_hours => 1,
      :extra_working_hours => 1,
      :base_salary => 1,
      :percentage_pay => 1,
      :holiday_pay => 1,
      :night_pay => 1,
      :extra_pay => 1,
      :no_absence_pay => 1,
      :no_accident_pay => 1,
      :long_service_pay => 1,
      :real_salary => 1,
      :health_insurance => 1,
      :nursing_insurance => 1,
      :pension => "",
      :unemployment_isurance => 1,
      :taxables => 1,
      :dependents => 1,
      :calculated_tax_amount => 1,
      :adjustment => 1,
      :net_collection => 1,
      :resident_tax => 1,
      :bonus => 1,
      :social_insurance => 1
    ).as_new_record)
  end

  it "renders new tax_withholding form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", tax_withholdings_path, "post" do
      assert_select "input#tax_withholding_working_days[name=?]", "tax_withholding[working_days]"
      assert_select "input#tax_withholding_working_hours[name=?]", "tax_withholding[working_hours]"
      assert_select "input#tax_withholding_holiday_working_hours[name=?]", "tax_withholding[holiday_working_hours]"
      assert_select "input#tax_withholding_night_working_hours[name=?]", "tax_withholding[night_working_hours]"
      assert_select "input#tax_withholding_extra_working_hours[name=?]", "tax_withholding[extra_working_hours]"
      assert_select "input#tax_withholding_base_salary[name=?]", "tax_withholding[base_salary]"
      assert_select "input#tax_withholding_percentage_pay[name=?]", "tax_withholding[percentage_pay]"
      assert_select "input#tax_withholding_holiday_pay[name=?]", "tax_withholding[holiday_pay]"
      assert_select "input#tax_withholding_night_pay[name=?]", "tax_withholding[night_pay]"
      assert_select "input#tax_withholding_extra_pay[name=?]", "tax_withholding[extra_pay]"
      assert_select "input#tax_withholding_no_absence_pay[name=?]", "tax_withholding[no_absence_pay]"
      assert_select "input#tax_withholding_no_accident_pay[name=?]", "tax_withholding[no_accident_pay]"
      assert_select "input#tax_withholding_long_service_pay[name=?]", "tax_withholding[long_service_pay]"
      assert_select "input#tax_withholding_real_salary[name=?]", "tax_withholding[real_salary]"
      assert_select "input#tax_withholding_health_insurance[name=?]", "tax_withholding[health_insurance]"
      assert_select "input#tax_withholding_nursing_insurance[name=?]", "tax_withholding[nursing_insurance]"
      assert_select "input#tax_withholding_pension[name=?]", "tax_withholding[pension]"
      assert_select "input#tax_withholding_unemployment_isurance[name=?]", "tax_withholding[unemployment_isurance]"
      assert_select "input#tax_withholding_taxables[name=?]", "tax_withholding[taxables]"
      assert_select "input#tax_withholding_dependents[name=?]", "tax_withholding[dependents]"
      assert_select "input#tax_withholding_calculated_tax_amount[name=?]", "tax_withholding[calculated_tax_amount]"
      assert_select "input#tax_withholding_adjustment[name=?]", "tax_withholding[adjustment]"
      assert_select "input#tax_withholding_net_collection[name=?]", "tax_withholding[net_collection]"
      assert_select "input#tax_withholding_resident_tax[name=?]", "tax_withholding[resident_tax]"
      assert_select "input#tax_withholding_bonus[name=?]", "tax_withholding[bonus]"
      assert_select "input#tax_withholding_social_insurance[name=?]", "tax_withholding[social_insurance]"
    end
  end
end
