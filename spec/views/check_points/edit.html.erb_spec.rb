require 'spec_helper'

describe "check_points/edit" do
  before(:each) do
    @check_point = assign(:check_point, stub_model(CheckPoint,
      :user => nil,
      :name => "MyString"
    ))
  end

  it "renders the edit check_point form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => check_points_path(@check_point), :method => "post" do
      assert_select "input#check_point_user", :name => "check_point[user]"
      assert_select "input#check_point_name", :name => "check_point[name]"
    end
  end
end
