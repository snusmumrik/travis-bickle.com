class AddFuelLpgToReport < ActiveRecord::Migration
  def change
    add_column :reports, :fuel_cost_lpg, :integer, after: :fuel_cost, null: false, default: 0
  end
end
