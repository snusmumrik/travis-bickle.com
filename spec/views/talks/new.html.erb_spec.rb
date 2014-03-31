require 'spec_helper'

describe "talks/new" do
  before(:each) do
    assign(:talk, stub_model(Talk,
      :sender_user_id => 1,
      :sender_car_id => 1,
      :receiver_user_id => 1,
      :receiver_car_id => 1,
      :received => false
    ).as_new_record)
  end

  it "renders new talk form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", talks_path, "post" do
      assert_select "input#talk_sender_user_id[name=?]", "talk[sender_user_id]"
      assert_select "input#talk_sender_car_id[name=?]", "talk[sender_car_id]"
      assert_select "input#talk_receiver_user_id[name=?]", "talk[receiver_user_id]"
      assert_select "input#talk_receiver_car_id[name=?]", "talk[receiver_car_id]"
      assert_select "input#talk_received[name=?]", "talk[received]"
    end
  end
end
