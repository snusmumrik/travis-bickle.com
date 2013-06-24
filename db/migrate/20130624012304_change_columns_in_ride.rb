class ChangeColumnsInRide < ActiveRecord::Migration
  def up
    change_column :rides, :passengers, :integer, :default => 0
    change_column :rides, :fare, :integer, :default => 0
  end

  def down
    change_column :rides, :passengers, :integer, :default => nil
    change_column :rides, :fare, :integer, :default => nil
  end
end
