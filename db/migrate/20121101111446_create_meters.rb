class CreateMeters < ActiveRecord::Migration
  def change
    create_table :meters do |t|
      t.references :car
      t.integer :meter
      t.integer :mileage
      t.integer :riding_mileage
      t.integer :riding_count
      t.integer :meter_fare_count

      t.timestamps
    end
    add_index :meters, :car_id
  end
end
