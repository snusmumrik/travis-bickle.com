require 'spec_helper'

describe "transfer_slips/show" do
  before(:each) do
    @transfer_slip = assign(:transfer_slip, stub_model(TransferSlip,
      :report => nil,
      :debit => "Debit",
      :debit_amount => 1,
      :credit => "Credit",
      :credit_amount => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Debit/)
    rendered.should match(/1/)
    rendered.should match(/Credit/)
    rendered.should match(/2/)
  end
end
