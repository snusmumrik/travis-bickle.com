class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.integer :sender_user_id
      t.integer :sender_car_id
      t.integer :receiver_user_id
      t.integer :receiver_car_id
      t.boolean :received

      t.timestamps
    end

    add_index :talks, :sender_user_id
    add_index :talks, :sender_car_id
    add_index :talks, :receiver_user_id
    add_index :talks, :receiver_car_id
  end
end
