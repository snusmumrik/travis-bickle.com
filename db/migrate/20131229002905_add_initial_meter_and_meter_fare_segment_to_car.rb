class AddInitialMeterAndMeterFareSegmentToCar < ActiveRecord::Migration
  def change
    add_column :cars, :initial_meter, :integer, :after => :meter_fare
    add_column :cars, :meter_fare_segment, :integer, :after => :initial_meter
  end
end
