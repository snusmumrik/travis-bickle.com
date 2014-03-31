require 'spec_helper'

describe "talks/index" do
  before(:each) do
    assign(:talks, [
      stub_model(Talk,
        :sender_user_id => 1,
        :sender_car_id => 2,
        :receiver_user_id => 3,
        :receiver_car_id => 4,
        :received => false
      ),
      stub_model(Talk,
        :sender_user_id => 1,
        :sender_car_id => 2,
        :receiver_user_id => 3,
        :receiver_car_id => 4,
        :received => false
      )
    ])
  end

  it "renders a list of talks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
