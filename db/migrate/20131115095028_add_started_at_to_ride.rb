class AddStartedAtToRide < ActiveRecord::Migration
  def up
    add_column :rides, :started_at, :datetime, :after => :fare
    change_column :rides, :ended_at, :datetime, :after => :started_at
  end

  def down
    remove_column :rides, :started_at
    change_column :rides, :ended_at, :datetime, :after => :deleted_at
  end
end
