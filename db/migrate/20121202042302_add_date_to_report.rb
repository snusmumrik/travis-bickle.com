class AddDateToReport < ActiveRecord::Migration
  def change
    add_column :reports, :date, :date, :after => :car_id
  end
end
