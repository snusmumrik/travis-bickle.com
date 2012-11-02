class CreateCheckPoints < ActiveRecord::Migration
  def change
    create_table :check_points do |t|
      t.references :user
      t.string :name
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :check_points, :user_id
  end
end
