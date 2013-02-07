class RemoveColumnsFromCars < ActiveRecord::Migration
  def up
    remove_column :cars, :car_type
    remove_column :cars, :car_model
    remove_column :cars, :twitter_id
    remove_column :cars, :twitter_name
  end

  def down
    add_column :cars, :car_type, :string, :after => :name
    add_column :cars, :car_model, :string, :after => :car_type
    add_column :cars, :twitter_id, :string, :after => :meter_fare
    add_column :cars, :twitter_name, :string, :after => :twitter_id
  end
end
