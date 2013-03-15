# require 'spec_helper'

# describe "rides/index" do
#   before(:each) do
#     assign(:rides, [
#       stub_model(Ride,
#         :report => nil,
#         :location => "Location",
#         :latitude => 1.5,
#         :longitude => 1.5
#       ),
#       stub_model(Ride,
#         :report => nil,
#         :location => "Location",
#         :latitude => 1.5,
#         :longitude => 1.5
#       )
#     ])
#   end

#   it "renders a list of rides" do
#     render
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "tr>td", :text => nil.to_s, :count => 2
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "tr>td", :text => "Location".to_s, :count => 2
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "tr>td", :text => 1.5.to_s, :count => 2
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "tr>td", :text => 1.5.to_s, :count => 2
#   end
# end
