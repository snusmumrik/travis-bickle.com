require 'spec_helper'

describe "talks/edit" do
  before(:each) do
    @talk = assign(:talk, stub_model(Talk,
      :sender_user_id => 1,
      :sender_car_id => 1,
      :receiver_user_id => 1,
      :receiver_car_id => 1,
      :received => false
    ))
  end

  it "renders the edit talk form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", talk_path(@talk), "post" do
      assert_select "input#talk_sender_user_id[name=?]", "talk[sender_user_id]"
      assert_select "input#talk_sender_car_id[name=?]", "talk[sender_car_id]"
      assert_select "input#talk_receiver_user_id[name=?]", "talk[receiver_user_id]"
      assert_select "input#talk_receiver_car_id[name=?]", "talk[receiver_car_id]"
      assert_select "input#talk_received[name=?]", "talk[received]"
    end
  end
end
