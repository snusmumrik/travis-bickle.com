require 'spec_helper'

describe "tax_withholdings/show" do
  before(:each) do
    @tax_withholding = assign(:tax_withholding, stub_model(TaxWithholding,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/8/)
    rendered.should match(/9/)
    rendered.should match(/10/)
    rendered.should match(/11/)
    rendered.should match(/12/)
    rendered.should match(/13/)
    rendered.should match(/14/)
    rendered.should match(/15/)
    rendered.should match(/16/)
    rendered.should match(//)
    rendered.should match(/17/)
    rendered.should match(/18/)
    rendered.should match(/19/)
    rendered.should match(/20/)
    rendered.should match(/21/)
    rendered.should match(/22/)
    rendered.should match(/23/)
    rendered.should match(/24/)
    rendered.should match(/25/)
  end
end
