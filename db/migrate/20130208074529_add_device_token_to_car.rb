class AddDeviceTokenToCar < ActiveRecord::Migration
  def change
    add_column :cars, :device_token, :string, :after => :access_token
  end
end
