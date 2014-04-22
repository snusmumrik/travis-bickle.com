require 'spec_helper'

describe "transfer_slips/edit" do
  before(:each) do
    @transfer_slip = assign(:transfer_slip, stub_model(TransferSlip,
      :report => nil,
      :debit => "MyString",
      :debit_amount => 1,
      :credit => "MyString",
      :credit_amount => 1
    ))
  end

  it "renders the edit transfer_slip form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", transfer_slip_path(@transfer_slip), "post" do
      assert_select "input#transfer_slip_report[name=?]", "transfer_slip[report]"
      assert_select "input#transfer_slip_debit[name=?]", "transfer_slip[debit]"
      assert_select "input#transfer_slip_debit_amount[name=?]", "transfer_slip[debit_amount]"
      assert_select "input#transfer_slip_credit[name=?]", "transfer_slip[credit]"
      assert_select "input#transfer_slip_credit_amount[name=?]", "transfer_slip[credit_amount]"
    end
  end
end
