class AddEndedAtToRide < ActiveRecord::Migration
  def change
    add_column :rides, :ended_at, :datetime, :after => :deleted_at
  end
end
