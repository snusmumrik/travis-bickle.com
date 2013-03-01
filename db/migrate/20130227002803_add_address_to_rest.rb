class AddAddressToRest < ActiveRecord::Migration
  def change
    add_column :rests, :address, :string, :after => :longitude
  end
end
