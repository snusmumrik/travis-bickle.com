class AddSegmentToRide < ActiveRecord::Migration
  def change
    add_column :rides, :segment, :integer, :default => 0, :after => :fare
  end
end
