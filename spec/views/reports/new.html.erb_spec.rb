require 'spec_helper'

describe "reports/new" do
  before(:each) do
    assign(:report, stub_model(Report,
      :driver => nil,
      :mileage => 1,
      :riding_mileage => 1,
      :riding_rate => 1.5,
      :riding_count => 1,
      :meter_fare_count => 1,
      :passengers => 1,
      :sales => 1,
      :sales_par_kilometer => 1,
      :fuel_cost => 1,
      :ticket => 1,
      :account_receivable => 1,
      :cash => 1,
      :surplus_funds => 1,
      :deficiency_account => 1,
      :advance => 1
    ).as_new_record)
  end

  it "renders new report form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reports_path, :method => "post" do
      assert_select "input#report_driver", :name => "report[driver]"
      assert_select "input#report_mileage", :name => "report[mileage]"
      assert_select "input#report_riding_mileage", :name => "report[riding_mileage]"
      assert_select "input#report_riding_rate", :name => "report[riding_rate]"
      assert_select "input#report_riding_count", :name => "report[riding_count]"
      assert_select "input#report_meter_fare_count", :name => "report[meter_fare_count]"
      assert_select "input#report_passengers", :name => "report[passengers]"
      assert_select "input#report_sales", :name => "report[sales]"
      assert_select "input#report_sales_par_kilometer", :name => "report[sales_par_kilometer]"
      assert_select "input#report_fuel_cost", :name => "report[fuel_cost]"
      assert_select "input#report_ticket", :name => "report[ticket]"
      assert_select "input#report_account_receivable", :name => "report[account_receivable]"
      assert_select "input#report_cash", :name => "report[cash]"
      assert_select "input#report_surplus_funds", :name => "report[surplus_funds]"
      assert_select "input#report_deficiency_account", :name => "report[deficiency_account]"
      assert_select "input#report_advance", :name => "report[advance]"
    end
  end
end
