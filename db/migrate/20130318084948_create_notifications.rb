class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user
      t.references :car
      t.string :text
      t.boolean :read
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :notifications, :car_id
  end
end
