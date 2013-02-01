class RemoveColumnFromDriver < ActiveRecord::Migration
  def up
    remove_column :drivers, :birthday
    remove_column :drivers, :blood_type
    remove_column :drivers, :licence_number
    remove_column :drivers, :start_working_at
  end

  def down
    add_column :drivers, :birthday, :date, :after => :name
    add_column :drivers, :blood_type, :string,  :after => :birthday
    add_column :drivers, :licence_number, :string, :after => :blood_type
    add_column :drivers, :start_working_at, :date, :after => :licence_number
  end
end
