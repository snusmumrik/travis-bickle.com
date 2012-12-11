class AddAddressToRide < ActiveRecord::Migration
  def change
    add_column :rides, :ride_address, :string, :after => :ride_longitude
    add_column :rides, :leave_address, :string, :after => :leave_longitude
  end
end
