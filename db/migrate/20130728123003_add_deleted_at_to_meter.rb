class AddDeletedAtToMeter < ActiveRecord::Migration
  def change
    add_column :meters, :deleted_at, :datetime, :after => :meter_fare_count
  end
end
