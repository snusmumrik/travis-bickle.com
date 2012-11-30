class AddMeterToReport < ActiveRecord::Migration
  def up
    add_column :reports, :meter, :integer, :after => :car_id
    remove_column :reports, :riding_rate
  end

  def down
    remove_column :reports, :meter
    add_column :reports, :riding_rate, :integer, :after => :riding_mileage
  end
end
