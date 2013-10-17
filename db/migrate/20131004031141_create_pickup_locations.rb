class CreatePickupLocations < ActiveRecord::Migration
  def change
    create_table :pickup_locations do |t|
      t.references :user
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :pickup_locations, :user_id
  end
end
