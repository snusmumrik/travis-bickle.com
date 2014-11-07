class CreateMinimumWages < ActiveRecord::Migration
  def change
    create_table :minimum_wages do |t|
      t.references :user
      t.integer :price

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
