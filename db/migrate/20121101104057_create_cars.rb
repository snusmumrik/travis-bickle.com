class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.references :user
      t.string :name
      t.string :car_type
      t.string :car_model
      t.integer :base_fare
      t.integer :meter_fare
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :cars, :user_id
  end
end

