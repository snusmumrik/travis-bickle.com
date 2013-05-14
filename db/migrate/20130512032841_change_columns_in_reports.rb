class ChangeColumnsInReports < ActiveRecord::Migration
  def up
    change_column :reports, :meter, :integer, :default => 0
    change_column :reports, :mileage, :integer, :default => 0
    change_column :reports, :riding_mileage, :integer, :default => 0
    change_column :reports, :riding_count, :integer, :default => 0
    change_column :reports, :meter_fare_count, :integer, :default => 0
    change_column :reports, :passengers, :integer, :default => 0
    change_column :reports, :sales, :integer, :default => 0
    change_column :reports, :fuel_cost, :integer, :default => 0
    change_column :reports, :ticket, :integer, :default => 0
    change_column :reports, :account_receivable, :integer, :default => 0
    change_column :reports, :cash, :integer, :default => 0
    change_column :reports, :surplus_funds, :integer, :default => 0
    change_column :reports, :deficiency_account, :integer, :default => 0
    change_column :reports, :advance, :integer, :default => 0
  end

  def down
    change_column :reports, :meter, :integer, :default => nil
    change_column :reports, :mileage, :integer, :default => nil
    change_column :reports, :riding_mileage, :integer, :default => nil
    change_column :reports, :riding_count, :integer, :default => nil
    change_column :reports, :meter_fare_count, :integer, :default => nil
    change_column :reports, :passengers, :integer, :default => nil
    change_column :reports, :sales, :integer, :default => nil
    change_column :reports, :fuel_cost, :integer, :default => nil
    change_column :reports, :ticket, :integer, :default => nil
    change_column :reports, :account_receivable, :integer, :default => nil
    change_column :reports, :cash, :integer, :default => nil
    change_column :reports, :surplus_funds, :integer, :default => nil
    change_column :reports, :deficiency_account, :integer, :default => nil
    change_column :reports, :advance, :integer, :default => nil
  end
end
