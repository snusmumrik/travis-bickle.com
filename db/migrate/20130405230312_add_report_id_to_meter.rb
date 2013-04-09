class AddReportIdToMeter < ActiveRecord::Migration
  def up
    add_column :meters, :report_id, :integer, :after => :id
    remove_column :meters, :car_id
    remove_column :meters, :date
    add_index :meters, :report_id
  end

  def down
    remove_column :meters, :report_id
    add_column :meters, :car_id, :Integer, :after => :id
    add_column :meters, :date, :date, :after => :car_id
    add_index :meters, :car_id
  end
end
