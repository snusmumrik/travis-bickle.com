require 'spec_helper'

describe "notifications/edit" do
  before(:each) do
    @notification = assign(:notification, stub_model(Notification,
      :car => nil,
      :text => "MyString",
      :read => false
    ))
  end

  it "renders the edit notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", notification_path(@notification), "post" do
      assert_select "input#notification_car[name=?]", "notification[car]"
      assert_select "input#notification_text[name=?]", "notification[text]"
      assert_select "input#notification_read[name=?]", "notification[read]"
    end
  end
end
