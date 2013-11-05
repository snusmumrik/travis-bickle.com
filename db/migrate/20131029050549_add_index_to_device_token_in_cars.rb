class AddIndexToDeviceTokenInCars < ActiveRecord::Migration
  def change
    add_index :cars, :device_token
  end
end
