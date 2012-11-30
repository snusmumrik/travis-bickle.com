require 'spec_helper'

describe "rests/new" do
  before(:each) do
    assign(:rest, stub_model(Rest,
      :report => nil,
      :location => "MyString",
      :latitude => 1.5,
      :longitude => 1.5
    ).as_new_record)
  end

  it "renders new rest form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => rests_path, :method => "post" do
      assert_select "input#rest_report", :name => "rest[report]"
      assert_select "input#rest_location", :name => "rest[location]"
      assert_select "input#rest_latitude", :name => "rest[latitude]"
      assert_select "input#rest_longitude", :name => "rest[longitude]"
    end
  end
end
