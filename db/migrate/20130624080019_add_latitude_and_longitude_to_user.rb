class AddLatitudeAndLongitudeToUser < ActiveRecord::Migration
  def change
    add_column :users, :address, :string, :after => :last_sign_in_ip
    add_column :users, :latitude, :float, :after => :address
    add_column :users, :longitude, :float, :after => :latitude
  end
end
