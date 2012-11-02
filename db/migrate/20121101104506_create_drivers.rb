class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.references :user
      t.string :name
      t.date :birthday
      t.string :blood_type
      t.string :licence_number
      t.date :start_working_at
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :drivers, :user_id
  end
end
