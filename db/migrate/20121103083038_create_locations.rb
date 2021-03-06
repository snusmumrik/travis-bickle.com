class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :car
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps

      t.timestamps
    end
    add_index :locations, :car_id
  end
end
