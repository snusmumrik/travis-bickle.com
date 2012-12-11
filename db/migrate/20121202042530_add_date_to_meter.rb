class AddDateToMeter < ActiveRecord::Migration
  def change
    add_column :meters, :date, :date, :after => :car_id
  end
end
