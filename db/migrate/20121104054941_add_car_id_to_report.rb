class AddCarIdToReport < ActiveRecord::Migration
  def change
    add_column :reports, :car_id, :int, :after => :driver_id
  end
end








