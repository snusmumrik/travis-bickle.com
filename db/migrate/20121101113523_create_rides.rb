class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.references :report
      t.float :ride_latitude
      t.float :ride_longitude
      t.float :leave_latitude
      t.float :leave_longitude
      t.integer :passengers
      t.integer :fare
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :rides, :report_id
  end
end
