class AddParametersToCar < ActiveRecord::Migration
  def change
    add_column :cars, :registration_number, :string, :after => :name
    add_column :cars, :identification_number, :string, :after => :registration_number
    add_column :cars, :model_number, :string, :after => :identification_number
    add_column :cars, :model_name, :string, :after => :model_number
    add_column :cars, :taxi_registration_date, :date, :after => :model_name
  end
end
