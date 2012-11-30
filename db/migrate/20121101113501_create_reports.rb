class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :driver
      t.integer :mileage
      t.integer :riding_mileage
      t.float :riding_rate
      t.integer :riding_count
      t.integer :meter_fare_count
      t.integer :passengers
      t.integer :sales
      t.integer :sales_par_kilometer # wrong spell, "per"
      t.integer :fuel_cost
      t.integer :ticket
      t.integer :account_receivable
      t.integer :cash
      t.integer :surplus_funds
      t.integer :deficiency_account
      t.integer :advance
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :reports, :driver_id
  end
end
