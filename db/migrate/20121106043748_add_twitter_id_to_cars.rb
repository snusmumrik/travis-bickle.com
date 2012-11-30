class AddTwitterIdToCars < ActiveRecord::Migration
  def change
    add_column :cars, :twitter_id, :integer, :after => :meter_fare
    add_column :cars, :twitter_name, :string, :after => :twitter_id
    add_column :cars, :access_token, :string, :after => :twitter_name
  end
end
