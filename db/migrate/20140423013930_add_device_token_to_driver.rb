class AddDeviceTokenToDriver < ActiveRecord::Migration
  def change
    add_column :drivers, :device_token, :string, :after => :password_digest
  end
end
