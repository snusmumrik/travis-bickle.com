require 'spec_helper'

describe "notifications/new" do
  before(:each) do
    assign(:notification, stub_model(Notification,
      :car => nil,
      :text => "MyString",
      :read => false
    ).as_new_record)
  end

  it "renders new notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", notifications_path, "post" do
      assert_select "input#notification_car[name=?]", "notification[car]"
      assert_select "input#notification_text[name=?]", "notification[text]"
      assert_select "input#notification_read[name=?]", "notification[read]"
    end
  end
end
