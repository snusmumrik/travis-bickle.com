class CreateDeviceTokens < ActiveRecord::Migration
  def change
    create_table :device_tokens do |t|
      t.references :user
      t.string :device_token
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :device_tokens, :user_id
  end
end
