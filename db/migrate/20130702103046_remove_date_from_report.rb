class RemoveDateFromReport < ActiveRecord::Migration
  def up
    remove_column :reports, :date
  end

  def down
    add_column :reports, :date, :date, :after => :car_id
  end
end
