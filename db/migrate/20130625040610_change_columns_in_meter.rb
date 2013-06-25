class ChangeColumnsInMeter < ActiveRecord::Migration
  def up
    change_column :meters, :meter, :integer, :default => 0
    change_column :meters, :mileage, :integer, :default => 0
    change_column :meters, :riding_mileage, :integer, :default => 0
    change_column :meters, :riding_count, :integer, :default => 0
  end

  def down
    change_column :meters, :meter, :integer, :default => nil
    change_column :meters, :mileage, :integer, :default => nil
    change_column :meters, :riding_mileage, :integer, :default => nil
    change_column :meters, :riding_count, :integer, :default => nil
  end
end
